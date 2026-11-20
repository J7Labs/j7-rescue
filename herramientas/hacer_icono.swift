import AppKit
// Dibuja el icono de la app (degradado J7 + iPhone con salvavidas) y lo guarda como PNG de 1024 px exactos.
let s = 1024
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: s, pixelsHigh: s, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let r = NSRect(x: 100, y: 100, width: 824, height: 824)
let p = NSBezierPath(roundedRect: r, xRadius: 185, yRadius: 185)
NSGraphicsContext.current?.saveGraphicsState()
let sombra = NSShadow(); sombra.shadowBlurRadius = 28; sombra.shadowOffset = NSSize(width: 0, height: -12); sombra.shadowColor = NSColor.black.withAlphaComponent(0.35); sombra.set()
NSColor.black.setFill(); p.fill()
NSGraphicsContext.current?.restoreGraphicsState()
NSGradient(colors: [NSColor(red: 0.25, green: 0.92, blue: 0.82, alpha: 1), NSColor(red: 0.62, green: 0.38, blue: 0.95, alpha: 1), NSColor(red: 0.88, green: 0.30, blue: 0.85, alpha: 1)])!.draw(in: p, angle: -50)
// iPhone
let tel = NSBezierPath(roundedRect: NSRect(x: 372, y: 232, width: 280, height: 560), xRadius: 62, yRadius: 62)
NSColor(white: 0.08, alpha: 0.9).setFill(); tel.fill()
NSColor.white.setStroke(); tel.lineWidth = 16; tel.stroke()
NSColor.white.setFill(); NSBezierPath(roundedRect: NSRect(x: 462, y: 740, width: 100, height: 22), xRadius: 11, yRadius: 11).fill()
// salvavidas
let c = NSImage.SymbolConfiguration(pointSize: 250, weight: .bold).applying(.init(paletteColors: [.white]))
if let i = NSImage(systemSymbolName: "lifepreserver", accessibilityDescription: nil)?.withSymbolConfiguration(c) {
    i.draw(at: NSPoint(x: 512 - i.size.width / 2, y: 480 - i.size.height / 2), from: .zero, operation: .sourceOver, fraction: 1)
}
NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
