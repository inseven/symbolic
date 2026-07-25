// Copyright (c) 2022-2026 Jason Morley
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

import SymbolicCore

import Interact

struct EditorView: View {

    @Environment(\.undoManager) var undoManager

    @EnvironmentObject var settings: Settings

    @ObservedObject var sceneModel: SceneModel
    @ObservedObject var document: IconDocument

    @State var undoContext = UndoContext()

    var body: some View {
        Form {
            
            Section("Icon") {
                SymbolPicker("Image",
                             selection: $document.icon.symbol.undoable(undoManager, context: undoContext),
                             sceneModel: sceneModel)
                Slider(value: $document.icon.iconScale.undoable(undoManager, context: undoContext), in: 0...1.2) {
                    Label("Size", systemImage: "textformat.size")
                }
                LabeledContent {
                    ColorPicker(selection: $document.icon.symbolColor.undoable(undoManager, context: undoContext),
                                supportsOpacity: false)
                } label: {
                    Label("Color", systemImage: "paintpalette")
                }
                LabeledContent {
                    VStack(alignment: .trailing) {
                        PositionOffsetSlider(title: "X",
                                             isHovering: $sceneModel.showOffsetX,
                                             value: $document.icon.iconOffset.width.undoable(undoManager,
                                                                                             context: undoContext))
                        PositionOffsetSlider(title: "Y",
                                             isHovering: $sceneModel.showOffsetY,
                                             value: $document.icon.iconOffset.height.undoable(undoManager,
                                                                                              context: undoContext))
                        Button("Reset") {
                            let offset = document.icon.iconOffset
                            undoManager?.registerUndo(undoContext) {
                                document.icon.iconOffset = offset
                            }
                            document.icon.iconOffset = .zero
                        }
                        .disabled(document.icon.iconOffset == .zero)
                    }
                } label: {
                    Label("Position", systemImage: "arrow.up.and.down.and.arrow.left.and.right")
                }
            }

            Section("Shadow") {
                Slider(value: $document.icon.shadowOpacity.undoable(undoManager, context: undoContext)) {
                    Label("Opacity", systemImage: "circle.bottomrighthalf.pattern.checkered")
                }
                Slider(value: $document.icon.shadowHeight.undoable(undoManager, context: undoContext)) {
                    Label("Height", systemImage: "arrow.up.and.down")
                }
            }

            Section("Background") {
                LabeledContent {
                    HStack {
                        ColorPicker(selection: $document.icon.topColor.undoable(undoManager, context: undoContext),
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
                            Image(systemName: "arrow.left.arrow.right")
                        }
                        ColorPicker(selection: $document.icon.bottomColor.undoable(undoManager, context: undoContext),
                                    supportsOpacity: false)
                    }
                } label: {
                    Label("Gradient", systemImage: "paint.bucket.classic")
                }
            }
#if DEBUG
            if settings.showIconDetails {
                Section("Details") {
                    LabeledContent("Family", value: document.icon.symbol.family)
                    LabeledContent("Name", value: document.icon.symbol.name)
                    LabeledContent("Variant", value: document.icon.symbol.variant ?? "")
                }
            }
#endif
        }
    }

}
