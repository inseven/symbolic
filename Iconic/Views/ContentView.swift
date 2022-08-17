// Copyright (c) 2022 Jason Morley
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

struct ContentView: View {

    @State var document = Document()

    var body: some View {
        HStack {
            VStack {
                ColorPicker(selection: $document.topColor) {
                    EmptyView()
                }
                Icon(document: document,
                     size: 512)
                .modifier(IconCorners(size: 512))
                ColorPicker(selection: $document.bottomColor) {
                    EmptyView()
                }
            }
            .padding()
            Form {
                Section("Icon") {
                    SymbolPicker("Image", systemImage: $document.systemImage)
                    Slider(value: $document.iconScale) {
                        Text("Size")
                    }
                    ColorPicker("Color", selection: $document.symbolColor)
                }
                Section("Shadow") {
                    Slider(value: $document.shadowOpacity) {
                        Text("Opacity")
                    }
                    Slider(value: $document.shadowHeight) {
                        Text("Height")
                    }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
        .toolbar(id: "main") {
            ExportToolbar(document: document)
        }
        .onChange(of: document.bottomColor) { newValue in
            document.topColor = Color(NSColor(newValue).lighter(by: 25))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
