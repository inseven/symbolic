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

struct IconDefinition: Identifiable {

    enum Style {
        case macOS
        case iOS
        case watchOS
    }

    var id = UUID()

    let style: Style
    let size: CGSize
    let scale: Int
    let description: String?

    init(_ style: Style, size: CGFloat, scale: Int, description: String? = nil) {
        self.style = style
        self.size = CGSize(width: size, height: size)
        self.scale = scale
        self.description = description
    }

}

protocol IconDefinitionsConvertible {
    func asIconDefinitions() -> [IconDefinition]
}

@resultBuilder struct IconDefinitionsBuilder {

    public static func buildBlock() -> [IconDefinition] {
        return []
    }

    public static func buildBlock(_ definitions: IconDefinition...) -> [IconDefinition] {
        return definitions
    }

    public static func buildBlock(_ values: IconDefinitionsConvertible...) -> [IconDefinition] {
        return values
            .flatMap { $0.asIconDefinitions() }
    }

}

extension Array: IconDefinitionsConvertible where Element == IconDefinition {

    func asIconDefinitions() -> [IconDefinition] {
        return self
    }

}
