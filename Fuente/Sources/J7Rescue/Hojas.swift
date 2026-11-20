import SwiftUI

struct HojaMarco<C: View>: View {
    let titulo: String
    @ViewBuilder var contenido: () -> C
    @Environment(\.dismiss) var cerrar
    var body: some View {
        VStack(spacing: 0) {
            HStack { Text(titulo).font(.title2.bold()); Spacer(); Button(L.t("btn.cerrar")) { cerrar() }.buttonStyle(.glass).keyboardShortcut(.cancelAction) }.padding(16)
            ScrollView { contenido().padding(.horizontal, 24).padding(.bottom, 24).frame(maxWidth: .infinity, alignment: .leading) }
        }.frame(width: 700, height: 640)
    }
}

struct HojaGuia: View {
    var body: some View {
        HojaMarco(titulo: L.t("guia.titulo")) {
            Text(L.t("guia.intro")).font(.callout).foregroundStyle(.secondary)
            MarkdownView(texto: L.documento("TUTORIAL"))
        }
    }
}

struct HojaPorque: View {
    @State private var fase = 0
    var body: some View {
        HojaMarco(titulo: L.t("porque.titulo")) {
            VStack(alignment: .leading, spacing: 14) {
                Casa(fase: fase).frame(width: 300, height: 300).frame(maxWidth: .infinity)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22))
                HStack {
                    ForEach(0..<4) { i in
                        if i == fase { Button("\(i + 1)") { fase = i }.buttonStyle(.glassProminent) }
                        else { Button("\(i + 1)") { withAnimation { fase = i } }.buttonStyle(.glass) }
                    }
                }.frame(maxWidth: .infinity)
                Text(L.t("porque.\(fase + 1)")).font(.title3).fixedSize(horizontal: false, vertical: true)
                Text(.init(L.t("porque.riesgo"))).font(.callout)
                Label(L.t("porque.video"), systemImage: "play.rectangle").padding(12).frame(maxWidth: .infinity)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14)).foregroundStyle(.secondary)
            }
        }
    }
}

struct HojaCreditos: View {
    @State private var verLicencias = false
    var body: some View {
        HojaMarco(titulo: L.t("cred.titulo")) {
            VStack(alignment: .leading, spacing: 16) {
                VStack(spacing: 8) {
                    if let u = Motor.recurso("j7labs.png"), let i = NSImage(contentsOf: u) {
                        Image(nsImage: i).resizable().scaledToFit().frame(width: 150, height: 150).clipShape(RoundedRectangle(cornerRadius: 28))
                    }
                    Text(L.t("cred.hecho")).font(.title3.bold())
                    Text("J7 Labs").foregroundStyle(.secondary)
                }.frame(maxWidth: .infinity)
                persona("Senne (3SENN)", L.t("cred.senne"), "https://github.com/3SENN/iphone-stuck-in-recovery-full-storage")
                persona("Igor Varyvoda", L.t("cred.igor"), "https://www.varyvoda.com/posts/iphone-error-100-full-storage-without-erasing/")
                persona(L.t("cred.lib.nombre"), L.t("cred.lib"), "https://libimobiledevice.org")
                Divider()
                Text(L.t("cred.lic.titulo")).font(.headline)
                Text(L.t("cred.mit")).font(.callout)
                Text(L.t("cred.lic.texto")).font(.callout).fixedSize(horizontal: false, vertical: true)
                VStack(alignment: .leading, spacing: 4) {
                    Link("idevicerestore (commit 60192e9)", destination: URL(string: "https://github.com/libimobiledevice/idevicerestore/tree/60192e97f87d1bbab5c493684e0a245b0966363f")!)
                    Link("libtatsu", destination: URL(string: "https://github.com/libimobiledevice/libtatsu")!)
                    Link("libirecovery", destination: URL(string: "https://github.com/libimobiledevice/libirecovery")!)
                    Link("libimobiledevice", destination: URL(string: "https://github.com/libimobiledevice/libimobiledevice")!)
                    Link("libusbmuxd", destination: URL(string: "https://github.com/libimobiledevice/libusbmuxd")!)
                    Link("libplist", destination: URL(string: "https://github.com/libimobiledevice/libplist")!)
                    Link("libimobiledevice-glue", destination: URL(string: "https://github.com/libimobiledevice/libimobiledevice-glue")!)
                    Link(L.t("cred.link.parche"), destination: URL(string: "https://github.com/3SENN/iphone-stuck-in-recovery-full-storage")!)
                }
                HStack {
                    Button(L.t("cred.ver")) { verLicencias.toggle() }.buttonStyle(.glass)
                    Button(L.t("cred.carpeta")) { if let u = Motor.recurso("Licencias") { NSWorkspace.shared.open(u) } }.buttonStyle(.glass)
                }
                if verLicencias { MarkdownView(texto: L.documento("AVISOS_LICENCIAS")) }
            }
        }
    }
    func persona(_ n: String, _ t: String, _ url: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(n).font(.headline)
            Text(t).fixedSize(horizontal: false, vertical: true)
            Link(url, destination: URL(string: url)!).font(.caption)
        }.padding(12).frame(maxWidth: .infinity, alignment: .leading).glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14))
    }
}
