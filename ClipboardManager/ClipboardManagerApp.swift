import SwiftUI

@main
struct ClipboardManagerApp: App {
    var body: some Scene {
            MenuBarExtra("Clipboard", systemImage: "doc.on.clipboard") {
                MainScreen()
            }
            .menuBarExtraStyle(.window)
        }
}

class AppState: ObservableObject {
    @Published var isWindowVisible = false
}
