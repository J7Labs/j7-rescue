import SwiftUI

struct Fondo: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.07, green: 0.10, blue: 0.20), Color(red: 0.17, green: 0.10, blue: 0.30)], startPoint: .topLeading, endPoint: .bottomTrailing)
            Circle().fill(turquesa.opacity(0.35)).frame(width: 420).blur(radius: 90).offset(x: -300, y: -200)
            Circle().fill(fucsia.opacity(0.30)).frame(width: 380).blur(radius: 90).offset(x: 320, y: 240)
        }.ignoresSafeArea()
    }
}

struct ContentView: View {
    @ObservedObject var m: Rescate
    var body: some View {
        ZStack {
            Fondo()
            VStack(spacing: 0) {
                if m.simulacion {
                    Text(L.t("sim.banner")).font(.caption.bold()).foregroundStyle(.black)
                        .frame(maxWidth: .infinity).padding(.vertical, 4).background(.yellow)
                }
                HStack(alignment: .top, spacing: 16) {
                    GlassEffectContainer(spacing: 16) {
                        VStack(spacing: 16) { ListaPasos(m: m); RegistroVista(m: m) }.frame(width: 330)
                    }
                    PanelDerecho(m: m)
                }.padding(16)
            }
        }
        .frame(minWidth: 960, minHeight: 640)
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItemGroup {
                Menu { ForEach(Idioma.allCases) { i in Button { m.cambiarIdioma(i) } label: { if i == m.idioma { Label(i.nombre, systemImage: "checkmark") } else { Text(i.nombre) } } } }
                    label: { Label(L.t("btn.idioma"), systemImage: "globe") }
                Button(L.t("btn.guia"), systemImage: "book") { m.hoja = .guia }
                Button(L.t("btn.porque"), systemImage: "questionmark.circle") { m.hoja = .porque }
                Button(L.t("btn.creditos"), systemImage: "heart") { m.hoja = .creditos }
            }
        }
        .sheet(item: $m.hoja) { h in
            switch h {
            case .guia: HojaGuia()
            case .porque: HojaPorque()
            case .creditos: HojaCreditos()
            case .confirmar: HojaConfirmar(m: m)
            }
        }
        .task { m.empezar() }
    }
}

struct ListaPasos: View {
    @ObservedObject var m: Rescate
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Paso.allCases) { p in
                let e = m.estados[p] ?? .pendiente
                HStack(spacing: 10) {
                    icono(e).frame(width: 24)
                    Text("\(p.rawValue + 1). \(p.titulo)").fontWeight(m.actual == p ? .semibold : .regular)
                    Spacer()
                    if p == .descarga, e == .activo, let pr = m.progreso { Text("\(Int(pr * 100)) %").monospacedDigit().foregroundStyle(.secondary) }
                }
                .padding(.vertical, 6).padding(.horizontal, 10)
                .background(m.actual == p ? AnyShapeStyle(.white.opacity(0.12)) : AnyShapeStyle(.clear), in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(12).frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
    }
    @ViewBuilder func icono(_ e: Estado) -> some View {
        switch e {
        case .hecho: Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
        case .fallo: Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
        case .activo: ProgressView().controlSize(.small).opacity(m.ocupado || m.enRescate ? 1 : 0).overlay { if !(m.ocupado || m.enRescate) { Image(systemName: "circle.dotted").foregroundStyle(turquesa) } }
        case .pendiente: Image(systemName: "circle").foregroundStyle(.secondary)
        }
    }
}

struct RegistroVista: View {
    @ObservedObject var m: Rescate
    static let f: DateFormatter = { let d = DateFormatter(); d.dateFormat = "HH:mm:ss"; return d }()
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L.t("log.titulo")).font(.headline)
            ScrollViewReader { sp in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 6) {
                        ForEach(m.lineas) { l in
                            HStack(alignment: .top, spacing: 6) {
                                Text(Self.f.string(from: l.hora)).font(.caption.monospacedDigit()).foregroundStyle(.secondary)
                                Text(l.texto).font(.callout).foregroundStyle(color(l.tipo)).fixedSize(horizontal: false, vertical: true)
                            }.id(l.id)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.onChange(of: m.lineas.count) { _, _ in if let u = m.lineas.last { withAnimation { sp.scrollTo(u.id, anchor: .bottom) } } }
            }
            if m.enRescate, !m.detalle.isEmpty { Text(m.detalle).font(.caption2.monospaced()).foregroundStyle(.secondary).lineLimit(2) }
        }
        .padding(14).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
    }
    func color(_ t: TipoLinea) -> Color { switch t { case .info: .primary; case .ok: .green; case .aviso: .orange; case .error: .red } }
}

struct PanelDerecho: View {
    @ObservedObject var m: Rescate
    var tranquilo: String {
        if m.terminado { return L.t("t.terminado") }
        switch m.actual {
        case .rescate: return L.t(m.enRescate ? "t.rescate.en" : "t.rescate")
        default: return L.t("t.\(m.actual.rawValue)")
        }
    }
    var body: some View {
        VStack(spacing: 14) {
            DibujoDePaso(m: m).padding(10)
                .frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 26))
                .frame(maxHeight: 400)
            Text(tranquilo).font(.title3).multilineTextAlignment(.center).frame(maxWidth: 520).fixedSize(horizontal: false, vertical: true)
            if let a = m.aviso {
                Label(a.texto, systemImage: "exclamationmark.triangle.fill").font(.callout).foregroundStyle(.orange).multilineTextAlignment(.leading)
                    .padding(10).frame(maxWidth: 520).glassEffect(.regular.tint(.orange.opacity(0.25)), in: RoundedRectangle(cornerRadius: 14))
            }
            if m.actual == .descarga, let p = m.progreso {
                VStack(spacing: 4) { ProgressView(value: p).frame(maxWidth: 360); Text(m.progresoTexto?.texto ?? "").font(.caption).foregroundStyle(.secondary) }
            }
            Botones(m: m)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Botones: View {
    @ObservedObject var m: Rescate
    var body: some View {
        HStack(spacing: 12) {
            switch m.actual {
            case .caso:
                if m.estados[.caso] == .fallo { Button(L.t("btn.otravez")) { Task { await m.comprobarCaso() } }.buttonStyle(.glassProminent) }
            case .recuperacion:
                Button(L.t("btn.buscar")) { m.buscarAhora() }.buttonStyle(.glass)
            case .descarga:
                Button(L.t(m.estados[.descarga] == .fallo ? "btn.reintentardesc" : "btn.descargar")) { Task { await m.descargar() } }
                    .buttonStyle(.glassProminent).disabled(m.ocupado)
            case .numero:
                if m.estados[.numero] == .fallo { Text(L.t("btn.problemaios")).foregroundStyle(.secondary) }
            case .rescate:
                if m.puedeReintentarMas { Button(L.t("btn.reintentar200")) { m.reintentarMas(); m.pedirConfirmacion() }.buttonStyle(.glassProminent) }
                else if !m.enRescate { Button(L.t("btn.rescatar")) { m.pedirConfirmacion() }.buttonStyle(.glassProminent).controlSize(.large).disabled(m.ocupado || m.valor == nil) }
                else { Label(L.t("btn.trabajando"), systemImage: "hourglass").foregroundStyle(.secondary) }
            case .arranque:
                if !m.terminado { Button(L.t("btn.yaarranco")) { m.todoBien() }.buttonStyle(.glassProminent).controlSize(.large) }
                else {
                    Link(L.t("btn.contarsenne"), destination: URL(string: "https://github.com/3SENN/iphone-stuck-in-recovery-full-storage/issues/new?template=result.yml")!).buttonStyle(.glass)
                    Button(L.t("btn.cerrar")) { NSApp.terminate(nil) }.buttonStyle(.glassProminent)
                }
            }
        }
    }
}

struct HojaConfirmar: View {
    @ObservedObject var m: Rescate
    @State private var texto = ""
    @Environment(\.dismiss) var cerrar
    var ok: Bool { ["si", "sí", "yes", "ja", "sim", "oui", "ok"].contains(texto.trimmingCharacters(in: .whitespaces).lowercased()) }
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "lifepreserver").font(.system(size: 44)).foregroundStyle(turquesa)
            Text(L.t("conf.titulo")).font(.title2.bold())
            Text(L.t("conf.texto", String(m.valor ?? 0)))
                .multilineTextAlignment(.center)
            TextField(L.t("conf.campo"), text: $texto).textFieldStyle(.roundedBorder).frame(width: 240).multilineTextAlignment(.center)
                .onSubmit { if ok { Task { await m.lanzarRescate() } } }
            HStack {
                Button(L.t("btn.cancelar")) { cerrar() }.keyboardShortcut(.cancelAction)
                Button(L.t("btn.empezar")) { Task { await m.lanzarRescate() } }.buttonStyle(.glassProminent).disabled(!ok).keyboardShortcut(.defaultAction)
            }
        }.padding(28).frame(width: 480)
        .onAppear { if m.auto { texto = "SI"; Task { await m.lanzarRescate() } } }
    }
}
