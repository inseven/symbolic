// “Commons Clause” License Condition v1.0
// 
// The Software is provided to you by the Licensor under the License, as defined
// below, subject to the following condition.
// 
// Without limiting other conditions in the License, the grant of rights under the
// License will not include, and the License does not grant to you, the right to
// Sell the Software.
// 
// For purposes of the foregoing, “Sell” means practicing any or all of the rights
// granted to you under the License to provide to third parties, for a fee or other
// consideration (including without limitation fees for hosting or consulting/
// support services related to the Software), a product or service whose value
// derives, entirely or substantially, from the functionality of the Software. Any
// license notice or attribution required by the License must also include this
// Commons Clause License Condition notice.
// 
// Software: Symbolic
// License: BSD 3-Clause License
// Licensor: InSeven Limited
// 
// ---
// 
// BSD 3-Clause License
// 
// Copyright (c) 2022-2023 InSeven Limited
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import SwiftUI

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
            if settings.showIconDetails {
                Section("Details") {
                    LabeledContent("Family", value: document.icon.symbol.family)
                    LabeledContent("Name", value: document.icon.symbol.name)
                    LabeledContent("Variant", value: document.icon.symbol.variant ?? "")
                }
            }
#endif
        }
        .formStyle(.grouped)
    }

}
