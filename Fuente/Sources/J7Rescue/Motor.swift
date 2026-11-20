import Foundation
import CryptoKit

struct IPhoneRec { var modo: String; var producto: String; var ecid: String }
struct Firmware { var url: URL; var sha1: String; var tam: Int64; var version: String; var build: String }
struct NumerosEspacio { var declarado: Int; var necesario: Int; var libre: Int }

enum ErrorRescate: Error { case msg(Msg) }
extension ErrorRescate { var msg: Msg { if case .msg(let m) = self { return m }; return Msg("err.generico") } }

/// Todo lo que «hace» la app, sin pantalla. Es lo mismo que hacía rescatar_iphone.sh.
enum Motor {
    // MARK: rutas
    static var contenido: URL { Bundle.main.bundleURL.appendingPathComponent("Contents") }
    static func helper(_ nombre: String) -> String { contenido.appendingPathComponent("Helpers/\(nombre)").path }
    static func recurso(_ nombre: String) -> URL? { Bundle.main.resourceURL?.appendingPathComponent(nombre) }

    static func carpetaTrabajo(simulacion: Bool) -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("J7 Rescue", isDirectory: true)
        let d = simulacion ? base.appendingPathComponent("Simulacion", isDirectory: true) : base
        for s in ["", "IPSW", "registros"] {
            try? FileManager.default.createDirectory(at: d.appendingPathComponent(s), withIntermediateDirectories: true)
        }
        return d
    }

    static let carpetaLogsFinder = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library/Logs/iPhone Updater Logs")

    // MARK: 1. diagnóstico
    enum Diagnostico {
        case esTuCaso(log: URL, build: String?, numeros: NumerosEspacio?)
        case sinRegistros
        case otroError(visto: Bool)
    }

    static func diagnosticar(carpetaLogs: URL = carpetaLogsFinder) -> Diagnostico {
        let fm = FileManager.default
        guard let nombres = try? fm.contentsOfDirectory(at: carpetaLogs, includingPropertiesForKeys: [.contentModificationDateKey]) else { return .sinRegistros }
        let logs = nombres.filter { $0.pathExtension == "log" }
            .sorted { (try? $0.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast >
                      (try? $1.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast }
        if logs.isEmpty { return .sinRegistros }
        var visto = false
        for l in logs {
            guard let t = leer(l) else { continue }
            if t.contains("SpaceNeededForRestore") { visto = true }
            if t.contains("Failed preallocation due to space") {
                return .esTuCaso(log: l, build: ultimoBuild(t), numeros: numerosEspacio(en: t))
            }
        }
        return .otroError(visto: visto)
    }

    static func leer(_ url: URL) -> String? {
        guard let d = try? Data(contentsOf: url) else { return nil }
        return String(data: d, encoding: .utf8) ?? String(decoding: d, as: UTF8.self)
    }

    static func ultimoBuild(_ t: String) -> String? {
        let re = try! NSRegularExpression(pattern: #"BuildNumber +=> +([0-9A-Za-z]+)"#)
        let ms = re.matches(in: t, range: NSRange(t.startIndex..., in: t))
        guard let m = ms.last, let r = Range(m.range(at: 1), in: t) else { return nil }
        return String(t[r])
    }

    /// Igual que read_space_numbers de suggest_cryptex_size.py (Senne).
    static func numerosEspacio(en t: String) -> NumerosEspacio? {
        let re = try! NSRegularExpression(pattern: #"Size of Cryptex1,SystemOS is (\d+) MB|SpaceNeededForRestore: (\d+) MB\s*ContainerFreeSpace: (\d+) MB"#)
        var declarado: Int?; var res: NumerosEspacio?
        func n(_ m: NSTextCheckingResult, _ i: Int) -> Int? { Range(m.range(at: i), in: t).flatMap { Int(t[$0]) } }
        for m in re.matches(in: t, range: NSRange(t.startIndex..., in: t)) {
            if let d = n(m, 1) { declarado = d }
            else if let d = declarado, let a = n(m, 2), let b = n(m, 3) { res = NumerosEspacio(declarado: d, necesario: a, libre: b) }
        }
        return res
    }

    // MARK: 2. iPhone en modo recuperación
    static func buscarIPhone(simulacion: Bool) async -> IPhoneRec? {
        if simulacion {
            if ProcessInfo.processInfo.environment["RESCATE_SIM_SIN_IPHONE"] != nil { return nil }
            return IPhoneRec(modo: "Recovery", producto: "iPhone18,2", ecid: "0xSIMULADO")
        }
        let (_, out) = await Proceso().correr(helper("irecovery"), ["-q"], timeout: 8)
        func v(_ k: String) -> String { out.split(separator: "\n").first { $0.hasPrefix(k + ":") }
            .map { $0.dropFirst(k.count + 1).trimmingCharacters(in: .whitespaces) } ?? "" }
        let ecid = v("ECID")
        guard !ecid.isEmpty else { return nil }
        return IPhoneRec(modo: v("MODE"), producto: v("PRODUCT"), ecid: ecid)
    }

    // MARK: 3. buscar y bajar iOS
    static let servidoresApple = ["https://updates.cdn-apple.com/", "https://secure-appldnld.apple.com/", "https://appldnld.apple.com/"]

    static func firmwareFirmado(producto: String, build: String?, simulacion: Bool) async throws -> Firmware {
        if simulacion {
            return Firmware(url: URL(string: "https://updates.cdn-apple.com/simulado/\(producto)_27.2.1_24B156_Restore.ipsw")!,
                            sha1: "simulado", tam: 13_000_000_000, version: "27.2.1", build: build ?? "24B156")
        }
        guard let url = URL(string: "https://api.ipsw.me/v4/device/\(producto)?type=ipsw") else { throw ErrorRescate.msg(Msg("err.modelo")) }
        let (datos, _) = try await URLSession.shared.data(from: url)
        guard let json = try JSONSerialization.jsonObject(with: datos) as? [String: Any],
              let fws = json["firmwares"] as? [[String: Any]] else { throw ErrorRescate.msg(Msg("err.ipswme")) }
        let firmados = fws.filter { ($0["signed"] as? Bool) == true }
        guard !firmados.isEmpty else { throw ErrorRescate.msg(Msg("err.nofirma")) }
        let elegido = firmados.first { ($0["buildid"] as? String) == build } ?? firmados[0]
        guard let u = (elegido["url"] as? String).flatMap(URL.init(string:)),
              let sha = elegido["sha1sum"] as? String,
              let ver = elegido["version"] as? String, let b = elegido["buildid"] as? String else { throw ErrorRescate.msg(Msg("err.ipswme.datos")) }
        let tam = (elegido["filesize"] as? NSNumber)?.int64Value ?? 0
        guard servidoresApple.contains(where: { u.absoluteString.hasPrefix($0) }) else {
            throw ErrorRescate.msg(Msg("err.noapple", u.host ?? "?"))
        }
        return Firmware(url: u, sha1: sha, tam: tam, version: ver, build: b)
    }

    static func espacioLibre(en url: URL) -> Int64 {
        (try? url.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage) ?? 0
    }

    static func tamano(_ url: URL) -> Int64 {
        ((try? FileManager.default.attributesOfItem(atPath: url.path))?[.size] as? NSNumber)?.int64Value ?? 0
    }

    /// SHA1 por trozos (el archivo pesa ~13 GB). Llama a `progreso` de 0 a 1.
    static func sha1(de url: URL, progreso: @escaping @Sendable (Double) -> Void) -> String? {
        guard let h = try? FileHandle(forReadingFrom: url) else { return nil }
        defer { try? h.close() }
        let total = Double(max(tamano(url), 1))
        var hasher = Insecure.SHA1(); var leido = 0.0; var ultimo = 0.0
        while let trozo = try? h.read(upToCount: 8 << 20), !trozo.isEmpty {
            hasher.update(data: trozo); leido += Double(trozo.count)
            if leido / total - ultimo > 0.01 { ultimo = leido / total; progreso(ultimo) }
        }
        return hasher.finalize().map { String(format: "%02x", $0) }.joined()
    }

    // MARK: 4. número del arreglo
    static func manifiesto(de ipsw: URL) async -> [String: Any]? {
        // unzip viene con todos los Mac; -p saca el archivo a la salida
        let p = Process(); p.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        p.arguments = ["-p", ipsw.path, "BuildManifest.plist"]
        let pipe = Pipe(); p.standardOutput = pipe; p.standardError = FileHandle.nullDevice
        guard (try? p.run()) != nil else { return nil }
        let datos = (try? pipe.fileHandleForReading.readToEnd()) ?? Data()
        p.waitUntilExit()
        return (try? PropertyListSerialization.propertyList(from: datos, format: nil)) as? [String: Any]
    }

    struct Calculo { var real: [String: Int]; var valor: Int; var version: String; var resumen: Msg }

    static func calcular(ipsw: URL, numeros: NumerosEspacio?) async throws -> Calculo {
        guard let m = await manifiesto(de: ipsw) else { throw ErrorRescate.msg(Msg("err.manifest")) }
        var tallas: [String: Int] = [:]
        for ident in (m["BuildIdentities"] as? [[String: Any]]) ?? [] {
            let info = ident["Info"] as? [String: Any] ?? [:]
            if (info["RestoreBehavior"] as? String) == "Update", let s = (info["Cryptex1,SystemOSSize"] as? NSNumber)?.intValue {
                tallas[(info["DeviceClass"] as? String) ?? "?"] = s
            }
        }
        guard !tallas.isEmpty else { throw ErrorRescate.msg(Msg("err.sincryptex")) }
        let ver = "\((m["ProductVersion"] as? String) ?? "?") (\((m["ProductBuildVersion"] as? String) ?? "?"))"
        if let n = numeros {
            let holgura = n.libre - n.necesario
            let v = n.declarado + holgura + 150
            return Calculo(real: tallas, valor: v, version: ver,
                           resumen: Msg("calc.conlog", String(n.declarado), String(n.necesario), String(n.libre), String(holgura)))
        }
        guard tallas.count == 1, let t = tallas.values.first else { throw ErrorRescate.msg(Msg("err.varios")) }
        return Calculo(real: tallas, valor: t + 748, version: ver,
                       resumen: Msg("calc.sinlog"))
    }

    static func iosPermiteActualizarSinBorrar(ipsw: URL, simulacion: Bool) async -> Bool {
        if simulacion { return true }
        let (_, out) = await Proceso().correr(helper("idevicerestore"), ["--ipsw-info", ipsw.path], timeout: 120)
        return out.range(of: #"Customer Upgrade Install \(IPSW\).*Behavior: Update"#, options: .regularExpression) != nil
    }

    // MARK: simulación (para probar sin tocar un iPhone)
    static func crearIPSWSimulado(en url: URL) {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent("sim-ipsw-\(UUID().uuidString)")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let man: [String: Any] = [
            "ProductVersion": "27.2.1", "ProductBuildVersion": "24B156", "SupportedProductTypes": ["iPhone18,2"],
            "BuildIdentities": [["Info": ["RestoreBehavior": "Update", "DeviceClass": "v54ap", "Cryptex1,SystemOSSize": 6030]]],
        ]
        let d = try? PropertyListSerialization.data(fromPropertyList: man, format: .xml, options: 0)
        try? d?.write(to: dir.appendingPathComponent("BuildManifest.plist"))
        try? FileManager.default.removeItem(at: url)
        let p = Process(); p.executableURL = URL(fileURLWithPath: "/usr/bin/zip")
        p.currentDirectoryURL = dir; p.arguments = ["-q", url.path, "BuildManifest.plist"]
        try? p.run(); p.waitUntilExit()
        try? FileManager.default.removeItem(at: dir)
    }
}
