import SwiftUI

let turquesa = Color(red: 0.25, green: 0.92, blue: 0.82)
let violeta = Color(red: 0.62, green: 0.38, blue: 0.95)
let fucsia = Color(red: 0.88, green: 0.30, blue: 0.85)

/// Lienzo lógico de 300×300 que se escala al cuadrado disponible.
struct Lienzo<C: View>: View {
    @ViewBuilder var contenido: () -> C
    var body: some View {
        GeometryReader { g in
            let e = min(g.size.width, g.size.height) / 300
            contenido().frame(width: 300, height: 300).scaleEffect(e)
                .position(x: g.size.width / 2, y: g.size.height / 2)
        }
    }
}

/// Un iPhone dibujado con sus botones.
struct Telefono<P: View>: View {
    var subir = false, bajar = false, lateral = false
    @ViewBuilder var pantalla: () -> P
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30).fill(.black.opacity(0.85)).frame(width: 130, height: 250)
            RoundedRectangle(cornerRadius: 30).stroke(.white.opacity(0.7), lineWidth: 3).frame(width: 130, height: 250)
            RoundedRectangle(cornerRadius: 22).fill(Color(white: 0.1)).frame(width: 112, height: 232)
            pantalla().frame(width: 112, height: 232).clipShape(RoundedRectangle(cornerRadius: 22))
            Capsule().fill(.black).frame(width: 36, height: 10).offset(y: -108)
            boton(subir).offset(x: -68, y: -50)
            boton(bajar).offset(x: -68, y: -12)
            boton(lateral, alto: 56).offset(x: 68, y: -40)
        }
    }
    func boton(_ on: Bool, alto: CGFloat = 30) -> some View {
        Capsule().fill(on ? Color.yellow : .white.opacity(0.55)).frame(width: 7, height: alto)
            .shadow(color: on ? .yellow : .clear, radius: on ? 8 : 0)
    }
}

struct DibujoRecuperacion: View {
    var body: some View {
        TimelineView(.animation) { tl in
            let f = Int(tl.date.timeIntervalSinceReferenceDate / 2.2) % 4
            Lienzo {
                ZStack {
                    Telefono(subir: f == 0, bajar: f == 1, lateral: f == 2) {
                        if f == 3 {
                            VStack(spacing: 10) {
                                Image(systemName: "cable.connector").font(.system(size: 30))
                                Image(systemName: "laptopcomputer").font(.system(size: 34))
                            }.foregroundStyle(.white)
                        } else { Color.black }
                    }.scaleEffect(0.76).offset(y: -28)
                    Text(L.t("rec.\(f + 1)"))
                        .font(.system(size: 15, weight: .semibold)).multilineTextAlignment(.center)
                        .frame(width: 290, height: 44).offset(y: 124)
                }
            }
        }
    }
}

struct DibujoLupa: View {
    var body: some View {
        Lienzo {
            ZStack {
                RoundedRectangle(cornerRadius: 14).fill(.white.opacity(0.9)).frame(width: 150, height: 190).offset(x: -20, y: 5)
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(0..<6, id: \.self) { i in Capsule().fill(i == 3 ? Color.orange : .gray.opacity(0.5)).frame(width: i == 3 ? 100 : 80 + CGFloat(i % 3) * 14, height: 8) }
                }.offset(x: -20, y: 5)
                Image(systemName: "magnifyingglass").font(.system(size: 100, weight: .light)).foregroundStyle(turquesa).offset(x: 50, y: 40)
            }
        }
    }
}

struct DibujoDescarga: View {
    var progreso: Double?
    var body: some View {
        Lienzo {
            ZStack {
                Image(systemName: "icloud").font(.system(size: 80)).foregroundStyle(.white).offset(y: -85)
                Image(systemName: "arrow.down").font(.system(size: 40, weight: .bold)).foregroundStyle(turquesa).offset(y: -25)
                Image(systemName: "laptopcomputer").font(.system(size: 90)).foregroundStyle(.white).offset(y: 55)
                if let p = progreso {
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.25)); Capsule().fill(LinearGradient(colors: [turquesa, violeta], startPoint: .leading, endPoint: .trailing)).frame(width: 220 * p)
                    }.frame(width: 220, height: 12).offset(y: 125)
                }
            }
        }
    }
}

/// La casa de dos plantas. fase 0: todo normal · 1: el guardia dice «cabe» · 2: no entra · 3: arreglo + limpieza
struct Casa: View {
    var fase: Int = 0
    var relleno: Double? = nil
    var numero: Int? = nil
    var body: some View {
        Lienzo {
            ZStack {
                Triangle().fill(fucsia.opacity(0.85)).frame(width: 250, height: 60).offset(y: -112)
                RoundedRectangle(cornerRadius: 8).fill(.white.opacity(0.14)).frame(width: 220, height: 80).offset(y: -45)
                RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.7), lineWidth: 2).frame(width: 220, height: 80).offset(y: -45)
                RoundedRectangle(cornerRadius: 8).fill(turquesa.opacity(0.35)).frame(width: 220, height: 80).offset(y: 40)
                RoundedRectangle(cornerRadius: 8).stroke(turquesa, lineWidth: 2).frame(width: 220, height: 80).offset(y: 40)
                Text(L.t("casa.abajo")).font(.system(size: 16, weight: .semibold)).offset(y: 40)
                // planta de arriba
                Group {
                    if let r = relleno {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6).fill(.clear).frame(width: 190, height: 14)
                            RoundedRectangle(cornerRadius: 6).fill(.white.opacity(0.25)).frame(width: 190, height: 14)
                            RoundedRectangle(cornerRadius: 6).fill(LinearGradient(colors: [turquesa, violeta], startPoint: .leading, endPoint: .trailing)).frame(width: 190 * r, height: 14)
                        }.offset(y: -45)
                        Text(L.t("casa.sistemanuevo")).font(.system(size: 14, weight: .semibold)).offset(y: -72)
                    } else {
                        Text(L.t("casa.arriba.\(min(fase, 3))"))
                            .font(.system(size: 15, weight: .semibold)).offset(y: -45)
                    }
                }
                if fase == 3 && relleno == nil { Image(systemName: "sparkles").font(.system(size: 26)).foregroundStyle(.yellow).offset(x: 100, y: -60) }
                if let n = numero {
                    Text(L.t("casa.numero", String(n))).font(.system(size: 13, weight: .bold, design: .monospaced)).padding(.horizontal, 8).padding(.vertical, 3)
                        .background(.black.opacity(0.5), in: Capsule()).offset(y: 112)
                }
            }
        }
    }
    struct Triangle: Shape { func path(in r: CGRect) -> Path { var p = Path(); p.move(to: CGPoint(x: r.midX, y: r.minY)); p.addLine(to: CGPoint(x: r.maxX, y: r.maxY)); p.addLine(to: CGPoint(x: r.minX, y: r.maxY)); p.closeSubpath(); return p } }
}

struct DibujoBarra: View {
    var lenta: Bool
    var terminado = false
    var body: some View {
        TimelineView(.animation) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let p = lenta ? (t / 14).truncatingRemainder(dividingBy: 1) : (t / 4).truncatingRemainder(dividingBy: 1)
            Lienzo {
                Telefono { 
                    VStack(spacing: 26) {
                        if terminado { Image(systemName: "checkmark.circle.fill").font(.system(size: 60)).foregroundStyle(.green) }
                        else {
                            Image(systemName: "apple.logo").font(.system(size: 54)).foregroundStyle(.white)
                            ZStack(alignment: .leading) {
                                Capsule().fill(.white.opacity(0.25)).frame(width: 70, height: 5)
                                Capsule().fill(.white).frame(width: 70 * p, height: 5)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DibujoDePaso: View {
    @ObservedObject var m: Rescate
    var body: some View {
        switch m.actual {
        case .caso: DibujoLupa()
        case .recuperacion: DibujoRecuperacion()
        case .descarga: DibujoDescarga(progreso: m.progreso)
        case .numero: Casa(fase: 3, numero: m.valor)
        case .rescate: m.enRescate ? AnyView(DibujoBarra(lenta: false)) : AnyView(Casa(fase: 3, numero: m.valor))
        case .arranque: DibujoBarra(lenta: true, terminado: m.terminado)
        }
    }
}
