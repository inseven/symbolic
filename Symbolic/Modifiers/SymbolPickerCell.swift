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

struct SymbolPickerCell: ViewModifier {

    struct LayoutMetrics {
        static let cornerRadius = 6.0
        static let padding = 6.0
    }

    let isHighlighted: Bool

    @State var isHovering: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: LayoutMetrics.cornerRadius)
                .fill(isHighlighted || isHovering ? Color(nsColor: NSColor.unemphasizedSelectedContentBackgroundColor) : .clear)
            content
                .controlSize(.regular)
                .foregroundColor(.primary)
                .padding(LayoutMetrics.padding)
        }
        .aspectRatio(1.0, contentMode: .fit)
        .onHover { isHovering in
            self.isHovering = isHovering
        }
    }

}

extension View {

    func symbolPickerCell(isHighlighted: Bool) -> some View {
        return modifier(SymbolPickerCell(isHighlighted: isHighlighted))
    }

}
