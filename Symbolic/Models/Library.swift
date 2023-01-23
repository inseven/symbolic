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

struct Library {

    struct License {

        let name: String
        let fileURL: URL?
        let url: URL?

    }

    let id: String
    let name: String
    let author: String
    let url: URL?
    let symbols: [Symbol]
    let symbolsById: [String:[Symbol]]
    let variants: [String: Variant]
    let license: License
    let warning: String?

    static var sfSymbols: Library = {
        return Library(id: "sf-symbols",
                       name: "SF Symbols",
                       author: "Apple Inc",
                       url: URL(string: "https://developer.apple.com/sf-symbols/")!,
                       symbols: SFSymbols.allSymbols,
                       variants: [],
                       license: License(name: "Agreements and Guidelines",
                                        fileURL: nil,
                                        url: URL(string: "https://developer.apple.com/support/terms/")!),
                       warning: "Apple sets out specific guidelines defining acceptable use of SF Symbols and explicitly prohibits their use in icons.\n\nEnsure you only use exported files containing SF Symbols in ways permitted under the relevant terms and conditions.")
    }()

    init(id: String,
         name: String,
         author: String,
         url: URL? = nil,
         symbols: [Symbol],
         variants: [Variant],
         license: License,
         warning: String? = nil) {
        self.id = id
        self.name = name
        self.author = author
        self.url = url
        self.symbols = symbols
        self.symbolsById = symbols.lookup()
        self.license = license
        self.variants = variants.reduce(into: [String: Variant]()) { partialResult, variant in
            partialResult[variant.id] = variant
        }
        self.warning = warning
    }

    init(directory: String) throws {
        guard  let manifestURL = Bundle.main.url(forResource: "manifest",
                                                 withExtension: "json",
                                                 subdirectory: directory) else {
            throw SymbolicError.missingManifest
        }
        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)

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
        self.author = manifest.author
        self.url = manifest.url
        self.symbols = symbols
        self.symbolsById = symbols.lookup()
        guard let fileURL =  Bundle.main.url(forResource: manifest.license.path,
                                             withExtension: nil,
                                             subdirectory: directory) else {
            throw SymbolicError.missingManifest
        }
        self.license = License(name: manifest.license.name, fileURL: fileURL, url: manifest.license.url)
        self.variants = variants
        self.warning = nil
    }

}

