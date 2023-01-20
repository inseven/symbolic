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

extension Array where Element == Symbol {

    func lookup() -> [String:[Symbol]] {
        return reduce(into: [String: [Symbol]]()) { partialResult, symbol in
            if partialResult[symbol.reference.name] == nil {
                partialResult[symbol.reference.name] = []
            }
            partialResult[symbol.reference.name]?.append(symbol)
        }
    }

}

struct FormattedText {

    let plain: String
    let html: String?

}

struct Library {

    let id: String
    let name: String
    let symbols: [Symbol]
    let symbolsById: [String:[Symbol]]
    let author: String
    let licenseUrl: URL?
    let variants: [String: Variant]
    let warning: FormattedText?

    static var sfSymbols: Library = {
        return Library(id: "sf-symbols",
                       name: "SF Symbols",
                       author: "Apple Inc",
                       symbols: SFSymbols.allSymbols,
                       variants: [],
                       warning: FormattedText(plain: "SF Symbols are licensed under a non-permissive license and are prohibited from use as icons.", html: nil))
    }()

    init(id: String,
         name: String,
         author: String,
         symbols: [Symbol],
         variants: [Variant],
         warning: FormattedText? = nil) {
        self.id = id
        self.name = name
        self.author = author
        self.symbols = symbols
        self.symbolsById = symbols.lookup()
        self.licenseUrl = nil
        self.variants = variants.reduce(into: [String: Variant]()) { partialResult, variant in
            partialResult[variant.id] = variant
        }
        self.warning = warning
    }

    init(directory: String) throws {
        let manifestURL = Bundle.main.url(forResource: "manifest",
                                          withExtension: "json",
                                          subdirectory: directory)!  // TODO: Throw
        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)

        // TODO: Exit cleanly if unable to load license

        let variants = manifest.variants.map { (id, variant) in
            return Variant(id: id, name: variant.name)
        }.reduce(into: [String: Variant]()) { partialResult, variant in
            partialResult[variant.id] = variant
        }

        let symbols: [Symbol] = manifest.symbols.map { symbol in
            let variants = symbol.variants.map { (identifier, variant) in
                let url = Bundle.main.url(forResource: variant.path, withExtension: nil, subdirectory: directory)
                let reference = SymbolReference(family: manifest.id, name: symbol.id, variant: identifier)
                let variant: Variant?
                if let variantId = reference.variant {
                    variant = variants[variantId]
                } else {
                    variant = nil
                }
                return Symbol(reference: reference, variant: variant, name: symbol.name, format: .svg, url: url)
            }
            return variants
        }.reduce([], +)

        self.id = manifest.id
        self.name = manifest.name
        self.symbols = symbols
        self.symbolsById = symbols.lookup()
        self.author = manifest.author
        self.licenseUrl = Bundle.main.url(forResource: manifest.license, withExtension: nil, subdirectory: directory)!
        self.variants = variants
        self.warning = nil
    }

}

