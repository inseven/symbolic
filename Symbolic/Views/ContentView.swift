// Copyright (c) 2022-2024 Jason Barrie Morley
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

struct ContentView: View {

    @EnvironmentObject var settings: Settings

    @ObservedObject var document: IconDocument

    @StateObject var sceneModel: SceneModel

    init(settings: Settings, document: IconDocument) {
        self.document = document
        _sceneModel = StateObject(wrappedValue: SceneModel(settings: settings, document: document))
    }

    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack {
                    ForEach(ApplicationModel.icons) { section in
                        Header(section.name)
                        CenteredFlowLayout {
                            ForEach(section.sets) { iconSet in
                                IconSetView(sceneModel: sceneModel, icon: document.icon, iconSet: iconSet)
                                    .padding()
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .background(Color(nsColor: .textBackgroundColor))
            .frame(maxWidth: .infinity, minHeight: 400)
            .cacheVectorGraphics(true)
            Divider()
            EditorView(sceneModel: sceneModel, document: document)
                .frame(width: 300)
        }
        .focusedSceneObject(document)
        .focusedSceneObject(sceneModel)
        .savePanel(isPresented: $sceneModel.showExportPanel, title: "Export", contentTypes: [.directory], options: [.canCreateDirectories]) {
            url in
            sceneModel.export(destination: url)
        }
        .alert("Export Icon?", isPresented: $sceneModel.showExportWarning, presenting: "Export") { text in
            Button("Export") {
                sceneModel.continueExport()
            }
            Button("Cancel") {
                sceneModel.cancelExport()
            }
        } message: { text in
            Text(sceneModel.library?.warning ?? "")
        }
        .showsError($sceneModel.lastError)
        .toolbar(id: "main") {
            ToolbarItem(id: "grid") {
                Toggle(isOn: $sceneModel.showGrid) {
                    Label("Grid", systemImage: "grid")
                }
                .help("Hide/show the icon grid")
            }
            ExportToolbar()
        }
        .environmentObject(sceneModel)
        .runs(sceneModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(settings: Settings(), document: IconDocument())
    }
}
