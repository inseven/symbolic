// Copyright (c) 2022 InSeven Limited
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

struct SymbolPicker: View {

    var title: String
    var systemImage: Binding<String>
    @State var initialImage: String
    @State var isPresented: Bool = false
    @StateObject var model = SymbolPickerModel()

    init(_ title: String, systemImage: Binding<String>) {
        self.title = title
        self.systemImage = systemImage
        _initialImage = State(initialValue: systemImage.wrappedValue)
    }

    let columns = [GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0)]

    var body: some View {
        LabeledContent("Symbol") {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Image(systemName: systemImage.wrappedValue)
                        .resizable()
                }
                .frame(width: 12, height: 12)
            }
            .popover(isPresented: $isPresented) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16.0) {
                        ForEach(model.filteredSymbolNames) { symbol in
                            HStack {
                                Image(systemName: symbol)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .controlSize(.regular)
                                    .onTapGesture {
                                        isPresented = false
                                        systemImage.wrappedValue = symbol
                                    }
                            }
                            .aspectRatio(1.0, contentMode: .fit)
                        }
                    }
                    .padding()
                }
                .safeAreaInset(edge: .top) {
                    TextField(text: $model.filter, prompt: Text("Search")) {
                        EmptyView()
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(.regularMaterial)
                }
                .frame(height: 400)
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
