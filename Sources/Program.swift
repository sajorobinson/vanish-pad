import SwiftUI

@main
struct VanishPadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Clear All…") {
                    NotificationCenter.default.post(name: .clearAllText, object: nil)
                }
                .keyboardShortcut("K", modifiers: [.command, .shift])
            }
        }

    }
}

extension Notification.Name {
    static let clearAllText = Notification.Name("clearAllText")
}
