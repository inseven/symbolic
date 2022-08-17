import Combine
import SwiftUI

struct ContentView: View {

    @State var iconScale: CGFloat = 0.5

    @State var document = Document()

    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your text"
        savePanel.message = "Choose a folder and a name to store your text."
        savePanel.nameFieldLabel = "File name:"
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }

    var body: some View {
        HStack {
            VStack {
                ColorPicker(selection: $document.topColor) {
                    EmptyView()
                }
                Icon(iconScale: iconScale,
                     document: document,
                     size: 512)
                .modifier(IconCorners(size: 512))
                ColorPicker(selection: $document.bottomColor) {
                    EmptyView()
                }
            }
            .padding()
            Form {
                Section("Icon") {
                    SymbolPicker("Image", systemImage: $document.systemImage)
                    Slider(value: $iconScale) {
                        Text("Size")
                    }
                    ColorPicker("Color", selection: $document.symbolColor)
                }
                Section("Shadow") {
                    Slider(value: $document.shadowOpacity) {
                        Text("Opacity")
                    }
                    Slider(value: $document.shadowHeight) {
                        Text("Height")
                    }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button("Export") {
                    let icon = Icon(iconScale: iconScale,
                                    document: document,
                                    size: 1024)
                    guard let data = icon.snapshot(scale: 2) else {
                        return
                    }
                    guard let url = showSavePanel() else {
                        return
                    }
                    do {
                        try data.write(to: url)
                    } catch {
                        print("Failed to write to file with error \(error)")
                    }

                }
            }
        }
        .onChange(of: document.bottomColor) { newValue in
            document.topColor = Color(NSColor(newValue).lighter(by: 25))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
