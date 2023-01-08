// Copyright (c) 2022-2023 InSeven Limited
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Combine
import SwiftUI

import Interact

class SceneModel: ObservableObject {

    @Published var showGrid = false

}

struct ContentView: View {

    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: IconDocument

    @StateObject var sceneModel = SceneModel()
    @State var undoContext = UndoContext()

    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack {
                    ForEach(ApplicationModel.icons) { section in
                        Header(section.name)
                        ForEach(section.sets) { iconSet in
                            IconSetView(icon: document.icon, iconSet: iconSet, showGrid: sceneModel.showGrid)
                        }
                    }
                }
                .padding()
                .horizontalSpace(.both)
            }
            .background(Color(nsColor: .textBackgroundColor))
            .frame(maxWidth: .infinity, minHeight: 400)
            Divider()
            Form {
                Section("Icon") {
                    SymbolPicker("Image", systemImage: $document.icon.systemImage.undoable(undoManager, context: undoContext))
                    Slider(value: $document.icon.iconScale.undoable(undoManager, context: undoContext)) {
                        Text("Size")
                    }
                    ColorPicker("Color", selection: $document.icon.symbolColor.undoable(undoManager, context: undoContext))
                }
                Section("Shadow") {
                    Slider(value: $document.icon.shadowOpacity.undoable(undoManager, context: undoContext)) {
                        Text("Opacity")
                    }
                    Slider(value: $document.icon.shadowHeight.undoable(undoManager, context: undoContext)) {
                        Text("Height")
                    }
                }
                Section("Background") {
                    ColorPicker("Top Color",
                                selection: $document.icon.topColor.undoable(undoManager, context: undoContext),
                                supportsOpacity: false)
                    Button {
                        let topColor = document.icon.topColor
                        let bottomColor = document.icon.bottomColor
                        undoManager?.registerUndo(undoContext) {
                            document.icon.topColor = topColor
                            document.icon.bottomColor = bottomColor
                        }
                        document.icon.topColor = bottomColor
                        document.icon.bottomColor = topColor
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .horizontalSpace(.both)
                    ColorPicker("Bottom Color",
                                selection: $document.icon.bottomColor.undoable(undoManager, context: undoContext),
                                supportsOpacity: false)
                }
            }
            .formStyle(.grouped)
            .frame(width: 300)
        }
        .focusedSceneObject(document)
        .focusedSceneObject(sceneModel)
        .toolbar(id: "main") {
            ToolbarItem(id: "grid") {
                Toggle(isOn: $sceneModel.showGrid) {
                    Label("Grid", systemImage: "grid")
                }
                .help("Hide/show the icon grid")
            }
            ExportToolbar(icon: document.icon)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
