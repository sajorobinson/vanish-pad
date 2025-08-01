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
                    // Send notification or use environment to clear text
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
