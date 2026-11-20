import Foundation

/// Lanza un programa y va entregando su salida línea a línea.
final class Proceso: @unchecked Sendable {
    private let candado = NSLock()
    private var proceso: Process?
    private var resto = ""
    private var acumulado = ""

    var corriendo: Bool { candado.lock(); defer { candado.unlock() }; return proceso?.isRunning ?? false }

    private func reiniciar(_ p: Process) { candado.lock(); proceso = p; resto = ""; acumulado = ""; candado.unlock() }
    private func vaciar() -> (String, String) { candado.lock(); defer { candado.unlock() }; let s = resto, o = acumulado; resto = ""; return (s, o) }

    /// Para el programa (SIGTERM).
    func parar() {
        candado.lock(); let p = proceso; candado.unlock()
        if let p, p.isRunning { kill(p.processIdentifier, SIGTERM) }
    }

    private func recibir(_ datos: Data, acumular: Bool, alLinea: (@Sendable (String) -> Void)?) {
        guard let texto = String(data: datos, encoding: .utf8) ?? String(data: datos, encoding: .isoLatin1) else { return }
        candado.lock()
        if acumular { acumulado += texto }
        resto += texto
        var lineas: [String] = []
        while let r = resto.rangeOfCharacter(from: CharacterSet(charactersIn: "\n\r")) {
            let l = String(resto[resto.startIndex..<r.lowerBound])
            resto.removeSubrange(resto.startIndex..<r.upperBound)
            if !l.trimmingCharacters(in: .whitespaces).isEmpty { lineas.append(l) }
        }
        candado.unlock()
        for l in lineas { alLinea?(l) }
    }

    /// Devuelve (código de salida, salida acumulada si `acumular`).
    func correr(_ exe: String, _ args: [String], env: [String: String] = [:], timeout: TimeInterval? = nil,
                acumular: Bool = true, alLinea: (@Sendable (String) -> Void)? = nil) async -> (Int32, String) {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: exe)
        p.arguments = args
        var e = ProcessInfo.processInfo.environment
        for (k, v) in env { e[k] = v }
        p.environment = e
        let pipe = Pipe()
        p.standardOutput = pipe
        p.standardError = pipe
        p.standardInput = FileHandle.nullDevice
        reiniciar(p)

        pipe.fileHandleForReading.readabilityHandler = { [weak self] h in
            let d = h.availableData
            if d.isEmpty { h.readabilityHandler = nil; return }
            self?.recibir(d, acumular: acumular, alLinea: alLinea)
        }
        return await withCheckedContinuation { (c: CheckedContinuation<(Int32, String), Never>) in
            p.terminationHandler = { [weak self] pr in
                guard let self else { c.resume(returning: (pr.terminationStatus, "")); return }
                pipe.fileHandleForReading.readabilityHandler = nil
                let rest = (try? pipe.fileHandleForReading.readToEnd()) ?? Data()
                if !rest.isEmpty { self.recibir(rest, acumular: acumular, alLinea: alLinea) }
                let (sobra, out) = self.vaciar()
                if !sobra.trimmingCharacters(in: .whitespaces).isEmpty { alLinea?(sobra) }
                c.resume(returning: (pr.terminationStatus, out))
            }
            do { try p.run() } catch {
                pipe.fileHandleForReading.readabilityHandler = nil
                c.resume(returning: (127, "No pude lanzar \(exe): \(error.localizedDescription)"))
                return
            }
            if let timeout {
                DispatchQueue.global().asyncAfter(deadline: .now() + timeout) { if p.isRunning { kill(p.processIdentifier, SIGTERM) } }
            }
        }
    }
}
