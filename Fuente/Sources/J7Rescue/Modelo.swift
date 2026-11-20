import SwiftUI
import UserNotifications

enum Paso: Int, CaseIterable, Identifiable {
    case caso, recuperacion, descarga, numero, rescate, arranque
    var id: Int { rawValue }
    var titulo: String { L.t("paso.\(rawValue)") }
}

enum Estado { case pendiente, activo, hecho, fallo }
enum TipoLinea { case info, ok, aviso, error }
struct Linea: Identifiable { let id = UUID(); let hora = Date(); let msg: Msg; let tipo: TipoLinea; var texto: String { msg.texto } }
enum Hoja: String, Identifiable { case guia, porque, creditos, confirmar; var id: String { rawValue } }

@MainActor
final class Rescate: ObservableObject {
    static let compartido = Rescate()

    let simulacion: Bool
    let auto: Bool
    let trabajo: URL

    @Published var idioma: Idioma = L.actual
    @Published var estados: [Paso: Estado] = Dictionary(uniqueKeysWithValues: Paso.allCases.map { ($0, .pendiente) })
    @Published var actual: Paso = .caso
    @Published var lineas: [Linea] = []
    @Published var progreso: Double? = nil
    @Published var progresoTexto: Msg? = nil
    @Published var ocupado = false
    @Published var detalle = ""
    @Published var aviso: Msg? = nil
    @Published var hoja: Hoja? = nil
    @Published var enRescate = false
    @Published var terminado = false
    @Published var momentoClave = false
    @Published var puedeReintentarMas = false
    @Published var valor: Int? = nil

    private var log: URL?
    private var build: String?
    private var numeros: NumerosEspacio?
    private var ipsw: URL?
    private var iphone: IPhoneRec?
    private var extra = 0
    private var sondeo: Task<Void, Never>?
    private let restore = Proceso()
    private var actividad: NSObjectProtocol?
    private var confirmadoSinBorrar = false

    init() {
        let args = CommandLine.arguments
        simulacion = args.contains("--simulacion") || args.contains("--simulacion-auto")
        auto = args.contains("--simulacion-auto")
        trabajo = Motor.carpetaTrabajo(simulacion: simulacion)
    }

    // MARK: utilidades
    func cambiarIdioma(_ i: Idioma) { L.poner(i); idioma = i }
    func decir(_ k: String, _ a: String..., tipo: TipoLinea = .info) { lineas.append(Linea(msg: Msg(k, a: a), tipo: tipo)) }
    func decir(_ m: Msg, tipo: TipoLinea = .info) { lineas.append(Linea(msg: m, tipo: tipo)) }
    /// Pone un aviso naranja en el panel y lo repite en el registro.
    func avisoYLog(_ m: Msg, tipo: TipoLinea = .error) { aviso = m; decir(m, tipo: tipo) }
    func poner(_ p: Paso, _ e: Estado) { estados[p] = e }
    func ir(a p: Paso) { actual = p; poner(p, .activo); aviso = nil }

    func notificar(_ k: String) {
        let c = UNMutableNotificationContent(); c.title = L.t(k + ".t"); c.body = L.t(k + ".c"); c.sound = .default
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: UUID().uuidString, content: c, trigger: nil))
    }

    // MARK: arranque
    func empezar() {
        if simulacion { decir("l.hola.sim", tipo: .aviso) } else { decir("l.hola") }
        decir("l.empiezo")
        if let a = CommandLine.arguments.first(where: { $0.hasPrefix("--abrir=") }) { hoja = Hoja(rawValue: String(a.dropFirst(8))) }
        Task { await comprobarCaso() }
    }

    // MARK: 1. caso
    func comprobarCaso() async {
        guard !ocupado else { return }
        ocupado = true; defer { ocupado = false }
        sondeo?.cancel()
        ir(a: .caso)
        let env = ProcessInfo.processInfo.environment["RESCATE_SIM_LOGS"]
        let d = (simulacion && env != nil) ? Motor.diagnosticar(carpetaLogs: URL(fileURLWithPath: env!)) : Motor.diagnosticar()
        switch d {
        case .sinRegistros:
            poner(.caso, .fallo)
            aviso = Msg("a.sinlogs")
            decir("l.sinlogs", tipo: .aviso)
        case .otroError(let visto):
            poner(.caso, .fallo)
            aviso = Msg("a.otroerror")
            decir(visto ? "l.otro.visto" : "l.otro.nada", tipo: .error)
        case .esTuCaso(let l, let b, let n):
            log = l; build = b; numeros = n
            decir("l.escaso", tipo: .ok)
            if let n { decir("l.finder", String(n.necesario), String(n.libre)) }
            if let b { decir("l.build", b, tipo: .ok) }
            poner(.caso, .hecho)
            ir(a: .recuperacion)
            decir("l.ponrecup")
            empezarSondeo()
        }
    }

    // MARK: 2. recuperación
    func empezarSondeo() {
        sondeo?.cancel()
        sondeo = Task { [weak self] in
            var avisado = false
            while !Task.isCancelled {
                guard let self, self.actual == .recuperacion else { return }
                if let r = await Motor.buscarIPhone(simulacion: self.simulacion) {
                    self.iphone = r
                    self.decir("l.encontrado", r.modo, r.producto, tipo: .ok)
                    self.poner(.recuperacion, .hecho)
                    self.ir(a: .descarga)
                    self.decir("l.siguiente")
                    if self.auto { Task { await self.descargar() } }
                    return
                } else if !avisado {
                    avisado = true
                    self.aviso = Msg("a.noveo")
                    self.decir("l.noveo", tipo: .aviso)
                }
                try? await Task.sleep(for: .seconds(2))
            }
        }
    }

    func buscarAhora() {
        Task {
            if await Motor.buscarIPhone(simulacion: simulacion) != nil { sondeo?.cancel(); empezarSondeo() }
            else { decir("l.sigonoveo", tipo: .aviso) }
        }
    }

    // MARK: 3. descarga
    func descargar() async {
        guard !ocupado, let iphone else { return }
        ocupado = true; defer { ocupado = false; progreso = nil; progresoTexto = nil }
        aviso = nil
        do {
            decir("l.preguntoapple", iphone.producto)
            let fw = try await Motor.firmwareFirmado(producto: iphone.producto, build: build, simulacion: simulacion)
            if let b = build, b != fw.build { decir("l.yanofirma", b, fw.version, fw.build, tipo: .aviso) }
            let destino = trabajo.appendingPathComponent("IPSW/\(fw.url.lastPathComponent)")
            let parcial = destino.appendingPathExtension("parte")
            ipsw = destino

            if simulacion {
                try await descargaSimulada(fw, destino)
            } else {
                if FileManager.default.fileExists(atPath: destino.path), await verificar(destino, fw) {
                    decir("l.yaestaba", destino.lastPathComponent, tipo: .ok)
                } else {
                    try? FileManager.default.removeItem(at: destino)
                    let libre = Motor.espacioLibre(en: trabajo), ya = Motor.tamano(parcial)
                    if libre + ya < fw.tam + 2_000_000_000 {
                        throw ErrorRescate.msg(Msg("err.espacio", String(fw.tam / 1_000_000_000 + 2), String(libre / 1_000_000_000)))
                    }
                    decir("l.descargando", fw.version, fw.build, String(fw.tam / 1_000_000))
                    try await bajar(fw, parcial: parcial)
                    try? FileManager.default.removeItem(at: destino)
                    try FileManager.default.moveItem(at: parcial, to: destino)
                    guard await verificar(destino, fw) else {
                        try? FileManager.default.removeItem(at: destino)
                        throw ErrorRescate.msg(Msg("err.sha"))
                    }
                }
            }
            decir("l.descargado", tipo: .ok)
            poner(.descarga, .hecho)
            notificar("n.descarga")
            try await prepararNumero(destino)
        } catch let e as ErrorRescate {
            poner(.descarga, .fallo); avisoYLog(e.msg)
        } catch {
            poner(.descarga, .fallo); avisoYLog(Msg("err.otro", error.localizedDescription))
        }
    }

    private func bajar(_ fw: Firmware, parcial: URL) async throws {
        let p = Proceso()
        let tam = fw.tam
        let vigia = Task { [weak self] in
            while !Task.isCancelled {
                let t = Motor.tamano(parcial)
                self?.progreso = tam > 0 ? min(Double(t) / Double(tam), 1) : nil
                self?.progresoTexto = Msg("p.gb", String(format: "%.1f", Double(t) / 1e9), String(format: "%.1f", Double(tam) / 1e9))
                try? await Task.sleep(for: .milliseconds(500))
            }
        }
        defer { vigia.cancel() }
        if Motor.tamano(parcial) < fw.tam || fw.tam == 0 {
            let (code, _) = await p.correr("/usr/bin/curl", ["-fL", "--proto", "=https", "-C", "-", "--retry", "5", "--retry-delay", "5", "-o", parcial.path, fw.url.absoluteString], acumular: false)
            if code != 0 { throw ErrorRescate.msg(Msg("err.curl", String(code))) }
        }
    }

    private func verificar(_ url: URL, _ fw: Firmware) async -> Bool {
        decir("l.verificando")
        progresoTexto = Msg("p.comprobando")
        let h = await Task.detached { Motor.sha1(de: url) { p in Task { @MainActor in Rescate.compartido.progreso = p } } }.value
        progreso = nil
        return h == fw.sha1
    }

    private func descargaSimulada(_ fw: Firmware, _ destino: URL) async throws {
        decir("l.sim.descarga", String(fw.tam / 1_000_000))
        for i in 1...20 {
            progreso = Double(i) / 20; progresoTexto = Msg("p.gb", String(format: "%.1f", 13.0 * Double(i) / 20), "13.0")
            try? await Task.sleep(for: .milliseconds(auto ? 60 : 250))
        }
        Motor.crearIPSWSimulado(en: destino)
    }

    // MARK: 4. número
    func prepararNumero(_ destino: URL) async throws {
        ir(a: .numero)
        decir("l.compruebo.opcion")
        guard await Motor.iosPermiteActualizarSinBorrar(ipsw: destino, simulacion: simulacion) else {
            poner(.numero, .fallo)
            throw ErrorRescate.msg(Msg("err.sinopcion"))
        }
        decir("l.tieneopcion", tipo: .ok)
        let c = try await Motor.calcular(ipsw: destino, numeros: numeros)
        for (k, v) in c.real { decir("l.tamreal", k, String(v)) }
        decir(c.resumen)
        valor = c.valor + extra
        decir("l.numero", String(valor!), tipo: .ok)
        poner(.numero, .hecho)
        ir(a: .rescate)
        decir("l.todolisto")
        if auto { Task { try? await Task.sleep(for: .seconds(1)); await self.lanzarRescate() } }
    }

    // MARK: 5. rescate
    func pedirConfirmacion() { hoja = .confirmar }

    func lanzarRescate() async {
        guard !ocupado, !enRescate, let ipsw, let valor else { return }
        hoja = nil; aviso = nil; puedeReintentarMas = false
        ocupado = true; defer { ocupado = false }
        guard let r = await Motor.buscarIPhone(simulacion: simulacion) else {
            aviso = Msg("a.noveo2")
            decir("l.noveo2", tipo: .error); return
        }
        iphone = r
        decir("l.listo", r.modo, tipo: .ok)
        if !simulacion {
            _ = await Proceso().correr("/usr/bin/pkill", ["-x", "MobileDeviceUpdater"])
            decir("l.cerrefinder")
        }
        // ---- Protecciones: nunca -e, siempre la variante de actualizar ----
        let variante = "Customer Upgrade Install (IPSW)"
        let args = ["-y", "-P", "-i", r.ecid, "--variant", variante, ipsw.path]
        guard !args.contains("-e"), !args.contains("--erase"), args.contains(variante) else {
            decir("l.proteccion", tipo: .error); return
        }
        let reg = trabajo.appendingPathComponent("registros/rescate_\(Int(Date().timeIntervalSince1970)).txt")
        FileManager.default.createFile(atPath: reg.path, contents: nil)
        let fh = try? FileHandle(forWritingTo: reg)

        poner(.rescate, .activo); enRescate = true; momentoClave = false; confirmadoSinBorrar = false
        actividad = ProcessInfo.processInfo.beginActivity(options: [.idleSystemSleepDisabled, .userInitiated], reason: "J7 Rescue")
        decir("l.empiezo.rescate")

        let exe: String, argv: [String]
        if simulacion {
            exe = "/bin/bash"; argv = [Motor.recurso("simulador_idevicerestore.sh")!.path] + args
        } else { exe = Motor.helper("idevicerestore"); argv = args }

        var borro = false
        let escribir = { (l: String) in fh?.write((l + "\n").data(using: .utf8)!) }
        let (code, _) = await restore.correr(exe, argv, env: ["IDEVICERESTORE_CRYPTEX_SIZE_MIB": String(valor)], acumular: false) { [weak self] l in
            escribir(l)
            Task { @MainActor in
                guard let self, !borro else { return }
                if self.revisar(l) { borro = true; self.restore.parar() }
            }
        }
        try? fh?.close()
        if let a = actividad { ProcessInfo.processInfo.endActivity(a); actividad = nil }
        enRescate = false
        concluir(codigo: code, texto: Motor.leer(reg) ?? "", borro: borro)
    }

    /// Devuelve true si hay que cortar (iba a borrar).
    private func revisar(_ l: String) -> Bool {
        if l.contains("will erase") || l.contains("Erase Install") || l.contains("erasing all") {
            poner(.rescate, .fallo)
            avisoYLog(Msg("l.borrar"))
            return true
        }
        detalle = l.count > 140 ? String(l.prefix(140)) + "…" : l
        if l.contains("without erasing user data") { if !confirmadoSinBorrar { confirmadoSinBorrar = true; decir("l.sinborrar", tipo: .ok) } }
        else if l.contains("Declaring Cryptex1,SystemOSSize") { decir("l.arreglo", tipo: .ok) }
        else if l.contains("Sending Cryptex1,SystemOS now") {
            decir("l.momento", tipo: .ok)
            if !momentoClave { momentoClave = true; notificar("n.momento") }
        }
        else if l.contains("Failed preallocation") { decir("l.faltasitio", tipo: .aviso) }
        else if l.contains("Sealing System Volume") { decir("l.sellando", tipo: .ok) }
        else if l.contains("Status: Restore Finished") { decir("l.macfin", tipo: .ok) }
        else if l.contains("ERROR") || l.contains("FAILURE") { decir("l.avisoraw", String(l.prefix(160)), tipo: .aviso) }
        return false
    }

    private func concluir(codigo: Int32, texto: String, borro: Bool) {
        if borro { return }
        if texto.contains("Status: Restore Finished") {
            poner(.rescate, .hecho)
            ir(a: .arranque)
            decir("l.terminobien", tipo: .ok)
            notificar("n.fin")
        } else if texto.contains("Failed preallocation") {
            poner(.rescate, .fallo); puedeReintentarMas = true
            avisoYLog(Msg("a.faltasitio"), tipo: .aviso)
        } else if texto.contains("downgrade_check") {
            poner(.rescate, .fallo); avisoYLog(Msg("a.viejo"))
        } else if texto.contains("Yonkers") {
            poner(.rescate, .fallo); avisoYLog(Msg("a.libtatsu"))
        } else {
            poner(.rescate, .fallo)
            avisoYLog(Msg("a.otromotivo", String(codigo)))
            for l in texto.split(separator: "\n").suffix(6) { decir("l.raw", String(l.prefix(160))) }
        }
    }

    func reintentarMas() { extra += 200; if let v = valor { valor = v + 200 }; poner(.rescate, .activo); puedeReintentarMas = false; aviso = nil; decir("l.reintento", String(valor ?? 0)) }

    // MARK: 6. arranque
    func todoBien() {
        poner(.arranque, .hecho); terminado = true
        decir("l.enhorabuena", tipo: .ok)
    }
}
