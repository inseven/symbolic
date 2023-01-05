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

struct ContentView: View {

    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var document: IconDocument

    @State var showGrid = false
    @State var undoContext = UndoContext()

    var body: some View {
        HStack(spacing: 0) {
            ScrollView {
                VStack {
                    Text("macOS")
                        .foregroundColor(.secondary)
                        .horizontalSpace(.leading)
                    Divider()
                    ForEach(ExportToolbar.icons["macOS"]!) { icon in
                        ZStack {
                            MacIconView(icon: document.icon, size: icon.size.width, isShadowFlipped: false)
                            if showGrid {
                                Image("Grid_macOS")
                                    .resizable()
                                    .frame(width: icon.size.width, height: icon.size.height)
                            }
                        }
                        Text("\(Int(icon.size.width))pt")
                            .foregroundColor(.secondary)
                    }
                    Text("iOS")
                        .foregroundColor(.secondary)
                        .horizontalSpace(.leading)
                    Divider()
                    ZStack {
                        IconView(icon: document.icon, size: 512, renderShadow: false)
                            .modifier(IconCorners(size: 512))
                        if showGrid {
                            Image("Grid_iOS")
                        }
                    }
                    Text("watchOS")
                        .foregroundColor(.secondary)
                        .horizontalSpace(.leading)
                    Divider()
                    IconView(icon: document.icon, size: 512, renderShadow: false)
                        .clipShape(Circle())
                }
                .padding()
                .horizontalSpace(.both)
            }
            .background(Color(nsColor: .textBackgroundColor))
            .frame(maxWidth: .infinity)
            Divider()
            Form {
                Section("Background") {
                    ColorPicker("Top Color",
                                selection: $document.icon.topColor.undoable(undoManager, context: undoContext),
                                supportsOpacity: false)
                    ColorPicker("Bottom Color",
                                selection: $document.icon.bottomColor.undoable(undoManager, context: undoContext),
                                supportsOpacity: false)
                }
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
            }
            .formStyle(.grouped)
            .frame(width: 300)
        }
        .toolbar(id: "main") {
            ToolbarItem(id: "grid") {
                Toggle(isOn: $showGrid) {
                    Label("Grid", systemImage: "grid")
                }
                .help("Hide/show the icon grid")
            }
            ExportToolbar(document: document.icon)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
