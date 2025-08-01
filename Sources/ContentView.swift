import SwiftUI

struct ContentView: View {
    @State private var fontStyle: String = "SF Mono"
    @State private var fontSize: CGFloat = 15
    @State private var showClearAlert = false
    @State private var text: String = """
        VanishPad can't save your work. 
        
        When you close this window, anything you've typed will be gone forever.
        """

    let availableSizes = Array(stride(from: 5, through: 120, by: 5))

    let availableFonts = [
        "SF Mono",
        "Menlo",
        "Georgia",
        "Helvetica Neue",
        "Lucida Grande",
    ]

    private var textEditorFont: Font {
        Font.custom(fontStyle, size: fontSize)
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            TextEditor(text: $text)
                .font(textEditorFont)
                .padding(.vertical, 7)
        }
        .alert("Clear all text?", isPresented: $showClearAlert) {
            Button("Clear", role: .destructive) {
                text = ""
            }
            Button("Cancel", role: .cancel) {}
        }
        .onReceive(NotificationCenter.default.publisher(for: .clearAllText)) { _ in
            showClearAlert = true
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
        )
        .toolbar {
            ToolbarItemGroup {

                Picker("Choose Text Style", selection: $fontStyle) {
                    ForEach(availableFonts, id: \.self) { fontName in
                        Text(fontName).tag(fontName)
                    }
                }

                Picker("Choose Text Size", selection: $fontSize) {
                    ForEach(availableSizes, id: \.self) { size in
                        Text("\(Int(size)) pt").tag(CGFloat(size))
                    }
                }
                .pickerStyle(.menu)

                Button("Make Text Smaller", systemImage: "textformat.size.smaller") {
                    fontSize = max(5, fontSize - 5)
                }
                .keyboardShortcut("-", modifiers: [.command])

                Button("Make Text Bigger", systemImage: "textformat.size.larger") {
                    fontSize = min(120, fontSize + 5)
                }
                .keyboardShortcut("+", modifiers: [.command])

                Button("Reset Text Size", systemImage: "textformat.size") {
                    fontSize = 15
                }
                .keyboardShortcut("0", modifiers: [.command])
            }
        }
    }
}
