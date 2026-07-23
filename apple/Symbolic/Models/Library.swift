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
    let aliases: [String: String]
    let variants: [String: Variant]
    let license: License
    let warning: String?

    func symbol(for reference: SymbolReference) -> Symbol? {
        let name = symbolsById[reference.name] != nil ? reference.name : aliases[reference.name]
        guard let name, let symbols = symbolsById[name] else {
            return nil
        }
        // Older documents may reference a symbol without naming a variant; fall
        // back to its default (first) variant in that case.
        guard let variant = reference.variant else {
            return symbols.first
        }
        return symbols.first { $0.reference.variant == variant }
    }

    init(named name: String) throws {
        guard let manifestURL = Bundle.main.url(forResource: "manifest",
                                                withExtension: "json",
                                                subdirectory: name) else {
            throw SymbolicError.missingManifest
        }
        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)

        let variants = (manifest.variants ?? [:]).map { (id, variant) in
            return Variant(id: id, name: variant.name)
        }.reduce(into: [String: Variant]()) { partialResult, variant in
            partialResult[variant.id] = variant
        }

        let symbols: [Symbol] = manifest.symbols.flatMap { symbol -> [Symbol] in
            return symbol.variants.map { (identifier, variant) in
                let reference = SymbolReference(family: manifest.id, name: symbol.id, variant: identifier)
                let displayVariant = variants[identifier]

                switch variant {
                case .svg(let properties):
                    let url = Bundle.main.url(forResource: properties.path, withExtension: nil, subdirectory: name)
                    return Symbol(reference: reference,
                                  variant: displayVariant,
                                  name: symbol.name ?? symbol.id,
                                  format: .svg(url: url))
                case .symbol(let properties):
                    return Symbol(reference: reference,
                                  variant: displayVariant,
                                  name: properties.name,
                                  format: .symbol(minimumOperatingSystemVersion: properties.minimumOperatingSystemVersion.flatMap { OperatingSystemVersion(string: $0) }))
                }
            }
        }

        let licenseFileURL: URL?
        if let path = manifest.license.path {
            guard let fileURL = Bundle.main.url(forResource: path, withExtension: nil, subdirectory: name) else {
                throw SymbolicError.missingLicense
            }
            licenseFileURL = fileURL
        } else {
            licenseFileURL = nil
        }

        self.id = manifest.id
        self.name = manifest.name
        self.author = manifest.author
        self.url = manifest.url
        self.symbols = symbols
        self.symbolsById = symbols.lookup()
        self.aliases = manifest.aliases ?? [:]
        self.variants = variants
        self.license = License(name: manifest.license.name, fileURL: licenseFileURL, url: manifest.license.url)
        self.warning = manifest.warning
    }

}
