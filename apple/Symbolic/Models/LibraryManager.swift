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

import Foundation

class LibraryManager {

    static let shared: LibraryManager = {
        return LibraryManager()
    }()

    let sets: [Library]

    init() {
        self.sets = [
            try! Library(named: "material-icons"),
            try! Library(named: "sf-symbols"),
        ]
    }

    func library(for reference: SymbolReference) -> Library? {
        return sets.first { $0.id == reference.family }
    }

    func symbol(for reference: SymbolReference) -> Symbol? {
        return library(for: reference)?.symbol(for: reference)
    }

    func resolveSymbol(for reference: SymbolReference) throws -> SymbolReference {
        guard let symbol = symbol(for: reference) else {
            throw SymbolicError.unknownSymbol
        }
        if case .symbol(let minimumOperatingSystemVersion?) = symbol.format,
           !ProcessInfo.processInfo.isOperatingSystemAtLeast(minimumOperatingSystemVersion) {
            throw SymbolicError.unsupportedOperatingSystemVersion
        }
        return symbol.reference
    }

}
