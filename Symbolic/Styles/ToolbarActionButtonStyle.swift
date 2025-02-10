// Copyright (c) 2022-2025 Jason Morley
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

struct ToolbarActionButtonStyle: ButtonStyle {
    
    @State var isHovering: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    struct LayoutMetrics {
        static let buttonCornerRadius = 6.0
        static let buttonPadding = 6.0
    }
    
    func brightness(for configuration: Configuration) -> CGFloat {
        switch colorScheme {
        case .dark:
            if configuration.isPressed {
                return 0.2
            } else if isHovering {
                return 0.1
            } else {
                return 0.0
            }
        default:
            if configuration.isPressed {
                return -0.2
            } else if isHovering {
                return 0.1
            } else {
                return 0.0
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.titleOnly)
            .padding(LayoutMetrics.buttonPadding)
            .foregroundColor(.white)
            .background(Color.accentColor
                .brightness(brightness(for: configuration))
                .cornerRadius(LayoutMetrics.buttonCornerRadius))
            .onHover { isHovering in
                withAnimation {
                    self.isHovering = isHovering
                }
            }
    }
    
}

extension ButtonStyle where Self == ToolbarActionButtonStyle {
    
    static var toolbarAction: Self {
        return .init()
    }
    
}
