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

import Combine
import SwiftUI

struct MacIconView: View {

    var icon: Icon
    var size: CGFloat
    var isShadowFlipped: Bool

    var body: some View {
        HStack {
            IconView(icon: icon, size: size * 0.8046875, isShadowFlipped: isShadowFlipped)
                .modifier(IconCorners(size: size * 0.8046875))
                .shadow(color: .black.opacity(0.3), radius: size * 0.0068359375, y: size * 0.009765625 * (isShadowFlipped ? -1.0 : 1.0))
        }
        .frame(width: size, height: size)
    }

}

struct ContentView: View {

    @EnvironmentObject var document: IconDocument

    @State var showGrid = false
    @State var previewType: PreviewType = .macOS

    var body: some View {
        HStack {
            VStack {
                ColorPicker(selection: $document.icon.topColor) {
                    EmptyView()
                }
                switch previewType {
                case .macOS:
                    ZStack {
                        MacIconView(icon: document.icon, size: 512, isShadowFlipped: false)
                        if showGrid {
                            Image("AppIconGrid")
                        }
                    }
                    .frame(width: 512, height: 512)
                case .iOS:
                    IconView(icon: document.icon, size: 512, renderShadow: false)
                        .modifier(IconCorners(size: 512))
                }
                ColorPicker(selection: $document.icon.bottomColor) {
                    EmptyView()
                }
            }
            .padding()
            Form {
                Section("Icon") {
                    SymbolPicker("Image", systemImage: $document.icon.systemImage)
                    Slider(value: $document.icon.iconScale) {
                        Text("Size")
                    }
                    ColorPicker("Color", selection: $document.icon.symbolColor)
                }
                Section("Shadow") {
                    Slider(value: $document.icon.shadowOpacity) {
                        Text("Opacity")
                    }
                    Slider(value: $document.icon.shadowHeight) {
                        Text("Height")
                    }
                }
            }
            .formStyle(.grouped)
        }
        .padding()
        .toolbar(id: "main") {
            ToolbarItem(id: "grid") {
                Toggle(isOn: $showGrid) {
                    Label("Toggle Grid", systemImage: "grid")
                }
            }
            PreviewToolbar(previewType: $previewType)
            ExportToolbar(document: document.icon)
        }
        .onChange(of: document.icon.bottomColor) { newValue in
            document.icon.topColor = Color(NSColor(newValue).lighter(by: 25))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
