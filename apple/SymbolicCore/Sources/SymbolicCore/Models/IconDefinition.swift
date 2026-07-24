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

public struct IconDefinition: Identifiable {

    public enum Style {
        case macOS
        case iOS
        case watchOS
        case web
    }

    public var id = UUID()

    public let style: Style
    public let size: CGSize
    public let scale: Int
    public let description: String?

    private let preferredBasename: String?

    public var basename: String {
        get throws {
            if let preferredBasename {
                return preferredBasename
            }
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            guard let sizeString = formatter.string(from: NSNumber(value: size.width)) else {
                throw SymbolicError.exportFailure
            }
            let scaleString = scale > 1 ? String(format: "@%dx", scale) : ""
            return "icon_\(sizeString)x\(sizeString)\(scaleString)"
        }
    }

    public init(_ style: Style, size: CGFloat, scale: Int, description: String? = nil, preferredBasename: String? = nil) {
        self.style = style
        self.size = CGSize(width: size, height: size)
        self.scale = scale
        self.description = description
        self.preferredBasename = preferredBasename
    }

}

public protocol IconDefinitionsConvertible {
    func asIconDefinitions() -> [IconDefinition]
}

@resultBuilder public struct IconDefinitionsBuilder {

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

    public func asIconDefinitions() -> [IconDefinition] {
        return self
    }

}
