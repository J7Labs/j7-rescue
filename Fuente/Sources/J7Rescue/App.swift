import SwiftUI
import UserNotifications

final class Delegado: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ n: Notification) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        NSApp.activate(ignoringOtherApps: true)
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ s: NSApplication) -> Bool { true }
    func userNotificationCenter(_ c: UNUserNotificationCenter, willPresent n: UNNotification) async -> UNNotificationPresentationOptions { [.banner, .sound] }
    @MainActor func applicationShouldTerminate(_ s: NSApplication) -> NSApplication.TerminateReply {
        guard Rescate.compartido.enRescate else { return .terminateNow }
        let a = NSAlert()
        a.messageText = L.t("q.titulo")
        a.informativeText = L.t("q.texto")
        a.addButton(withTitle: L.t("q.seguir")); a.addButton(withTitle: L.t("q.cerrar"))
        return a.runModal() == .alertFirstButtonReturn ? .terminateCancel : .terminateNow
    }
}

@main
struct J7RescueApp: App {
    @NSApplicationDelegateAdaptor(Delegado.self) var delegado
    var body: some Scene {
        WindowGroup("J7 Rescue") { ContentView(m: Rescate.compartido) }
            .defaultSize(width: 1040, height: 700)
            .windowToolbarStyle(.unified)
    }
}
