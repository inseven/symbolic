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

import SwiftUI

import Interact

struct EditorView: View {

    @Environment(\.undoManager) var undoManager

    @ObservedObject var sceneModel: SceneModel
    @ObservedObject var document: IconDocument

    @State var undoContext = UndoContext()

    var body: some View {
        Form {
            Section("Icon") {
                SymbolPicker("Image", selection: $document.icon.symbol.undoable(undoManager, context: undoContext))
                Slider(value: $document.icon.iconScale.undoable(undoManager, context: undoContext), in: 0...1.2) {
                    Text("Size")
                }
                ColorPicker("Color",
                            selection: $document.icon.symbolColor.undoable(undoManager, context: undoContext),
                            supportsOpacity: false)
                Slider(value:  $document.icon.iconOffset.width.undoable(undoManager, context: undoContext), in: -0.5...0.5) {
                    Text("X Offset")
                        .onTapGesture(count: 2) {
                            let width = document.icon.iconOffset.width
                            undoManager?.registerUndo(undoContext) {
                                document.icon.iconOffset.width = width
                            }
                            document.icon.iconOffset.width = 0
                        }
                }
                .onHover { isHovering in
                    sceneModel.showOffsetX = isHovering
                }
                Slider(value:  $document.icon.iconOffset.height.undoable(undoManager, context: undoContext), in: -0.5...0.5) {
                    Text("Y Offset")
                        .onTapGesture(count: 2) {
                            let height = document.icon.iconOffset.height
                            undoManager?.registerUndo(undoContext) {
                                document.icon.iconOffset.height = height
                            }
                            document.icon.iconOffset.height = 0
                        }
                }
                .onHover { isHovering in
                    sceneModel.showOffsetY = isHovering
                }
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
#if DEBUG
            Section("Details") {
                LabeledContent("Family", value: document.icon.symbol.family)
                LabeledContent("Name", value: document.icon.symbol.name)
                LabeledContent("Variant", value: document.icon.symbol.variant ?? "")
            }
#endif
        }
        .formStyle(.grouped)
    }

}
