import Foundation

/// Idiomas de la app. Los textos viven en Resources/<carpeta>.lproj/Localizable.strings
/// (y las guías largas en TUTORIAL.<carpeta>.md, etc.). Se puede cambiar en caliente.
enum Idioma: String, CaseIterable, Identifiable {
    case es, en, nl, pt, fr
    var id: String { rawValue }
    var carpeta: String { self == .pt ? "pt-BR" : rawValue }
    var nombre: String {
        switch self { case .es: "Español"; case .en: "English"; case .nl: "Nederlands"; case .pt: "Português (Brasil)"; case .fr: "Français" }
    }
    static func delSistema() -> Idioma {
        for l in Locale.preferredLanguages {
            let c = l.lowercased()
            if c.hasPrefix("es") { return .es }; if c.hasPrefix("en") { return .en }; if c.hasPrefix("nl") { return .nl }
            if c.hasPrefix("pt") { return .pt }; if c.hasPrefix("fr") { return .fr }
        }
        return .en
    }
}

/// Un mensaje por clave + argumentos: se traduce al mostrarlo, así cambia de idioma al instante.
struct Msg: Equatable {
    let k: String; let a: [String]
    init(_ k: String, _ a: String...) { self.k = k; self.a = a }
    init(_ k: String, a: [String]) { self.k = k; self.a = a }
    var texto: String { L.t(k, a) }
}

enum L {
    static var actual: Idioma = {
        if let e = ProcessInfo.processInfo.environment["J7_IDIOMA"], let i = Idioma(rawValue: e) { return i }
        if let r = UserDefaults.standard.string(forKey: "idioma"), let i = Idioma(rawValue: r) { return i }
        return Idioma.delSistema()
    }()
    static func poner(_ i: Idioma) { actual = i; UserDefaults.standard.set(i.rawValue, forKey: "idioma") }

    private static var cache: [String: Bundle] = [:]
    private static func bundle(_ i: Idioma) -> Bundle? {
        if let b = cache[i.carpeta] { return b }
        guard let p = Bundle.main.path(forResource: i.carpeta, ofType: "lproj"), let b = Bundle(path: p) else { return nil }
        cache[i.carpeta] = b; return b
    }
    static func t(_ k: String, _ a: [String] = []) -> String {
        var f = bundle(actual)?.localizedString(forKey: k, value: "\u{1}", table: nil) ?? "\u{1}"
        if f == "\u{1}" { f = bundle(.es)?.localizedString(forKey: k, value: k, table: nil) ?? k }
        return a.isEmpty ? f : String(format: f, arguments: a.map { $0 as CVarArg })
    }
    static func t(_ k: String, _ a: String...) -> String { t(k, a) }

    /// Documento largo (p. ej. «TUTORIAL» -> TUTORIAL.fr.md), con el español como respaldo.
    static func documento(_ nombre: String, ext: String = "md") -> String {
        for i in [actual, .es] {
            if let u = Motor.recurso("\(nombre).\(i.rawValue).\(ext)"), let s = try? String(contentsOf: u, encoding: .utf8) { return s }
        }
        return "(\(nombre))"
    }
}
