// Copyright (c) 2022-2023 Jason Barrie Morley
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

struct LibraryInfoView: View {

    private struct LayoutMetrics {
        static let width = 300.0
        static let height = 400.0
    }

    let library: Library

    public init(library: Library) {
        self.library = library
    }

    public var body: some View {
        ScrollView {
            VStack {
                LabeledContent("Library") {
                    Text(library.name)
                        .conditionalLink(library.url)
                }
                Divider()

                LabeledContent("Author", value: library.author)
                Divider()

                LabeledContent("License") {
                    Text(library.license.name)
                        .conditionalLink(library.license.url)
                }
                if library.warning != nil {
                    Divider()
                }

                if let warning = library.warning {
                    Text(warning)
                        .multilineTextAlignment(.center)
                        .padding()
                }

            }
            .padding()
            .labeledContentStyle(.info)
        }
        .multilineTextAlignment(.leading)
        .background(Color.textBackgroundColor)
        .navigationTitle(library.name)
        .frame(idealWidth: LayoutMetrics.width, maxWidth: LayoutMetrics.width, maxHeight: LayoutMetrics.height)
        .foregroundColor(.primary)
    }

}
