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

struct SymbolPicker: View {

    struct LayoutMetrics {
        static let itemSize = 38.0
        static let interItemSpacing = 6.0
        static let height = 400.0
    }

    var title: String
    var selection: Binding<Symbol>
    @State var isPresented: Bool = false
    @StateObject var model = SymbolPickerModel()

    init(_ title: String, selection: Binding<Symbol>) {
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
            Button {
                isPresented = true
            } label: {
                HStack {
                    SymbolView(symbol: selection.wrappedValue)
                        .imageScale(.large)
                }
                .frame(width: 32, height: 32)
            }
            .controlSize(.large)
            .popover(isPresented: $isPresented) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: LayoutMetrics.interItemSpacing, pinnedViews: [.sectionHeaders]) {
                        ForEach(model.filteredSymbols) { section in
                            Section {
                                ForEach(section.symbols) { symbol in
                                    SymbolView(symbol: symbol)
                                        .modifier(SymbolPickerCell(isHighlighted: selection.wrappedValue == symbol))
                                        .onTapGesture {
                                            isPresented = false
                                            selection.wrappedValue = symbol
                                        }
                                        .help(symbol.name)
                                }
                            } header: {
                                Text(section.id.name)
                                    .textCase(.uppercase)
                                    .horizontalSpace(.trailing)
                                    .ignoresSafeArea()
                            }
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                }
                .background(Color(nsColor: NSColor.controlBackgroundColor))
                .safeAreaInset(edge: .top) {
                    TextField(text: $model.filter, prompt: Text("Search")) {
                        EmptyView()
                    }
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(Color(nsColor: NSColor.controlBackgroundColor))
                }
                .frame(height: LayoutMetrics.height)
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
