// Copyright (c) 2022-2024 Jason Morley
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
import UniformTypeIdentifiers

import Interact

struct SavePanel: ViewModifier {

    struct Options: OptionSet {
        let rawValue: Int

        static let canCreateDirectories = Options(rawValue: 1 << 0)
        static let isExtensionHidden = Options(rawValue: 1 << 1)
        static let allowsOtherFileTypes = Options(rawValue: 1 << 2)
    }

    @Binding var isPresented: Bool
    let title: String
    let contentTypes: [UTType]
    let options: Options
    let action: (URL) -> Void
    @State var window: NativeWindow? = nil

    init(isPresented: Binding<Bool>,
         title: String,
         contentTypes: [UTType],
         options: Options,
         perform action: @escaping (URL) -> Void) {
        self.title = title
        _isPresented = isPresented
        self.contentTypes = contentTypes
        self.options = options
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .hookWindow { window in
                self.window = window
            }
            .onChange(of: isPresented) { newValue in
                guard newValue,
                      let window = window
                else {
                    return
                }
                let savePanel = NSSavePanel()
                savePanel.allowedContentTypes = contentTypes
                savePanel.canCreateDirectories = options.contains(.canCreateDirectories)
                savePanel.isExtensionHidden = options.contains(.isExtensionHidden)
                savePanel.allowsOtherFileTypes = options.contains(.allowsOtherFileTypes)
                savePanel.title = title
                savePanel.beginSheetModal(for: window) { response in
                    isPresented = false
                    guard response == .OK,
                          let url = savePanel.url
                    else {
                        return
                    }
                    action(url)
                }
            }
    }

}

extension View {

    func savePanel(isPresented: Binding<Bool>,
                   title: String,
                   contentTypes: [UTType],
                   options: SavePanel.Options = [],
                   perform action: @escaping (URL) -> Void) -> some View {
        modifier(SavePanel(isPresented: isPresented,
                           title: title,
                           contentTypes: contentTypes,
                           options: options,
                           perform: action))
    }

}
