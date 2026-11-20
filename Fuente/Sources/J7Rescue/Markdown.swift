import SwiftUI

/// Muestra un .md sencillo (títulos, listas, citas, código) dentro de la app.
struct MarkdownView: View {
    let texto: String
    enum Bloque: Identifiable { case h(Int, String), p(String), cita(String), codigo(String), item(String), linea
        var id: UUID { UUID() } }

    var bloques: [Bloque] {
        var out: [Bloque] = []; var parrafo: [String] = []; var cita: [String] = []; var codigo: [String]? = nil
        func cierra() {
            if !parrafo.isEmpty { out.append(.p(parrafo.joined(separator: " "))); parrafo = [] }
            if !cita.isEmpty { out.append(.cita(cita.joined(separator: "\n"))); cita = [] }
        }
        for l in texto.components(separatedBy: "\n") {
            if l.hasPrefix("```") {
                if let c = codigo { out.append(.codigo(c.joined(separator: "\n"))); codigo = nil } else { cierra(); codigo = [] }
                continue
            }
            if codigo != nil { codigo!.append(l); continue }
            let t = l.trimmingCharacters(in: .whitespaces)
            if t.isEmpty { cierra() }
            else if t == "---" { cierra(); out.append(.linea) }
            else if t.hasPrefix("### ") { cierra(); out.append(.h(3, String(t.dropFirst(4)))) }
            else if t.hasPrefix("## ") { cierra(); out.append(.h(2, String(t.dropFirst(3)))) }
            else if t.hasPrefix("# ") { cierra(); out.append(.h(1, String(t.dropFirst(2)))) }
            else if t.hasPrefix(">") { if !parrafo.isEmpty { cierra() }; cita.append(String(t.dropFirst(1)).trimmingCharacters(in: .whitespaces)) }
            else if t.hasPrefix("- ") || t.hasPrefix("* ") { cierra(); out.append(.item(String(t.dropFirst(2)))) }
            else if let r = t.range(of: #"^\d+\. "#, options: .regularExpression) { cierra(); out.append(.item(String(t[r.lowerBound...]))) }
            else { if !cita.isEmpty { cierra() }; parrafo.append(t) }
        }
        cierra()
        if let c = codigo { out.append(.codigo(c.joined(separator: "\n"))) }
        return out
    }

    func inline(_ s: String) -> Text {
        if let a = try? AttributedString(markdown: s, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)) { return Text(a) }
        return Text(s)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(bloques) { b in
                switch b {
                case .h(let n, let t): inline(t).font(n == 1 ? .title.bold() : n == 2 ? .title2.bold() : .headline).padding(.top, n == 1 ? 0 : 8)
                case .p(let t): inline(t).fixedSize(horizontal: false, vertical: true)
                case .cita(let t): inline(t).padding(10).frame(maxWidth: .infinity, alignment: .leading)
                        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                case .codigo(let t): Text(t).font(.system(.callout, design: .monospaced)).textSelection(.enabled).padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading).background(.black.opacity(0.18), in: RoundedRectangle(cornerRadius: 10))
                case .item(let t): HStack(alignment: .top) { Text("•"); inline(t).fixedSize(horizontal: false, vertical: true) }
                case .linea: Divider()
                }
            }
        }.textSelection(.enabled)
    }
}
