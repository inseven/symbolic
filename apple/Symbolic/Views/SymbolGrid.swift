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

struct SymbolGrid: View {

    @ObservedObject var model: SymbolPickerModel
    var selection: Binding<SymbolReference>
    @Binding var isPresented: Bool

    @State private var isScrolled = false

    private let columns = Array(repeating: GridItem(.flexible(minimum: SymbolPicker.LayoutMetrics.itemSize),
                                                    spacing: SymbolPicker.LayoutMetrics.interItemSpacing),
                                count: 5)

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVGrid(columns: columns,
                          spacing: SymbolPicker.LayoutMetrics.interItemSpacing,
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
                                .padding([.top, .bottom], SymbolPicker.LayoutMetrics.sectionHeaderVerticalPadding)
                                .background(.regularMaterial, ignoresSafeAreaEdges: .horizontal)
                        }
                    }
                }
                .padding(.bottom, SymbolPicker.LayoutMetrics.standardPadding)
                .safeAreaPadding(.horizontal, SymbolPicker.LayoutMetrics.standardPadding)
            }
            .opacity(isScrolled ? 1.0 : 0.0)
            .overlay {
                if !isScrolled {
                    ProgressView()
                }
            }
            .onAppear {
                reveal(proxy: proxy)
            }
            .onChange(of: model.filteredSymbols.isEmpty) { _, _ in
                reveal(proxy: proxy)
            }
        }
    }

    private func reveal(proxy: ScrollViewProxy) {
        guard !isScrolled, !model.filteredSymbols.isEmpty else {
            return
        }
        DispatchQueue.main.async {
            proxy.scrollTo(selection.wrappedValue.id, anchor: .center)
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isScrolled = true
                }
            }
        }
    }

}
