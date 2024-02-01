// Copyright (c) 2022-2024 Jason Barrie Morley
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

struct IconSet: Identifiable {

    let id = UUID()

    let name: String
    let definitions: [IconDefinition]

    init(_ name: String, @IconDefinitionsBuilder definitions: () -> [IconDefinition] = { [] }) {
        self.name = name
        self.definitions = definitions()
    }

}

protocol IconSetsConvertible {
    func asIconSets() -> [IconSet]
}

@resultBuilder struct IconSetsBuilder {

    public static func buildBlock() -> [IconSet] {
        return []
    }

    public static func buildBlock(_ sets: IconSet...) -> [IconSet] {
        return sets
    }

    public static func buildBlock(_ values: IconSetsConvertible...) -> [IconSet] {
        return values
            .flatMap { $0.asIconSets() }
    }

}

extension Array: IconSetsConvertible where Element == IconSet {

    func asIconSets() -> [IconSet] {
        return self
    }

}
