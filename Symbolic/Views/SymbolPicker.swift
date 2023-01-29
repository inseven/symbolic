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

struct SymbolPicker: View {

    struct LayoutMetrics {
        static let itemSize = 38.0
        static let interItemSpacing = 6.0
        static let height = 400.0
        static let buttonSize = CGSize(width: 24.0, height: 24.0)
        static let sectionHeaderVerticalPadding = 8.0
    }

    var title: String
    var selection: Binding<SymbolReference>
    @State var isPresented: Bool = false
    @StateObject var model = SymbolPickerModel()

    init(_ title: String, selection: Binding<SymbolReference>) {
        self.title = title
        self.selection = selection
    }

    let columns = [GridItem(.flexible(minimum: LayoutMetrics.itemSize), spacing: LayoutMetrics.interItemSpacing),
                   GridItem(.flexible(minimum: LayoutMetrics.itemSize), spacing: LayoutMetrics.interItemSpacing),
                   GridItem(.flexible(minimum: LayoutMetrics.itemSize), spacing: LayoutMetrics.interItemSpacing),
                   GridItem(.flexible(minimum: LayoutMetrics.itemSize), spacing: LayoutMetrics.interItemSpacing),
                   GridItem(.flexible(minimum: LayoutMetrics.itemSize), spacing: LayoutMetrics.interItemSpacing)]

    var body: some View {
        LabeledContent("Symbol") {
            VStack(alignment: .trailing) {
                Button {
                    isPresented = true
                } label: {
                    HStack {
                        SymbolView(symbolReference: selection.wrappedValue)
                    }
                    .frame(width: LayoutMetrics.buttonSize.width, height: LayoutMetrics.buttonSize.height)
                }
                .controlSize(.large)
                .popover(isPresented: $isPresented) {

                    VStack(spacing: 0) {
                        TextField(text: $model.filter, prompt: Text("Search")) {
                            EmptyView()
                        }
                        .multilineTextAlignment(.leading)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .background(Color(nsColor: NSColor.controlBackgroundColor))

                        ScrollView {
                            LazyVGrid(columns: columns,
                                      spacing: LayoutMetrics.interItemSpacing,
                                      pinnedViews: [.sectionHeaders]) {
                                ForEach(model.filteredSymbols) { section in
                                    Section {
                                        ForEach(section.symbols) { symbol in
                                            SymbolView(symbolReference: symbol.reference)
                                                .symbolPickerCell(isHighlighted: selection.wrappedValue == symbol.reference)
                                                .onTapGesture {
                                                    isPresented = false
                                                    selection.wrappedValue = symbol.reference
                                                }
                                                .help(symbol.localizedDescription)
                                        }
                                    } header: {
                                        Text(section.name)
                                            .textCase(.uppercase)
                                            .horizontalSpace(.trailing)
                                            .padding([.top, .bottom], LayoutMetrics.sectionHeaderVerticalPadding)
                                            .background(Color(nsColor: NSColor.controlBackgroundColor))
                                    }
                                }
                            }
                                      .padding([.leading, .trailing, .bottom])
                        }
                    }
                    .background(Color(nsColor: NSColor.controlBackgroundColor))
                    .frame(height: LayoutMetrics.height)
                }
                if let library = LibraryManager.shared.library(for: selection.wrappedValue) {
                    LibraryInfoButton(library: library)
                }
            }
        }
        .onAppear {
            model.start()
        }
        .onDisappear {
            model.stop()
        }

    }

}
