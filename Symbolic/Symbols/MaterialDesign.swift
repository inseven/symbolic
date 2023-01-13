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

import Foundation

struct Symbol: Identifiable {

    var id: String {
        return reference.id
    }

    enum Format {
        case svg
        case symbol
    }

    let reference: SymbolReference
    let format: Format
    let url: URL?

    var name: String {
        return reference.name
    }
}

struct Manifest: Codable {

    struct Variant: Codable {
        let path: String
    }

    struct Symbol: Codable {
        let name: String
        let variants: [String: Variant]
    }

    let id: String
    let name: String
    let symbols: [Symbol]

}

// TODO: Protocol?
struct SymbolSet {

    let id: String
    let name: String
    let symbols: [Symbol]

    static var sfSymbols: SymbolSet = {
        return SymbolSet(id: "sf-symbols", name: "SF Symbols", symbols: SFSymbols.allSymbols)
    }()

    init(id: String, name: String, symbols: [Symbol]) {
        self.id = id
        self.name = name
        self.symbols = symbols
    }

    init(directory: String) throws {

        let manifestURL = Bundle.main.url(forResource: "manifest", withExtension: "json", subdirectory: directory)!  // TODO: Throw
        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)

        self.id = manifest.id
        self.name = manifest.name

        self.symbols = manifest.symbols.map { symbol in
            let variants = symbol.variants.map { (identifier, variant) in
                let url = Bundle.main.url(forResource: variant.path, withExtension: nil, subdirectory: directory)
                let reference = SymbolReference(family: manifest.id, name: symbol.name)  // TODO: Include the variant in the identifier
                return Symbol(reference: reference, format: .svg, url: url)
            }
            return variants
        }.reduce([], +)
        
    }

}

