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

public struct Library {

    static let defaultVariantIdentifier = "default"

    public struct License {

        public let name: String
        public let fileURL: URL?
        public let url: URL?

    }

    public let id: String
    public let name: String
    public let author: String
    public let url: URL?
    public let symbols: [Symbol]
    public let symbolsById: [String:[Symbol]]
    public let aliases: [String: String]
    public let variants: [String: Variant]
    public let license: License
    public let warning: String?

    public func symbol(for reference: SymbolReference) -> Symbol? {
        let name = symbolsById[reference.name] != nil ? reference.name : aliases[reference.name]
        guard let name, let symbols = symbolsById[name] else {
            return nil
        }
        // Older documents may reference a symbol without naming a variant; fall
        // back to its default (first) variant in that case.
        guard let variant = reference.variant else {
            return symbols.first { $0.reference.variant == Self.defaultVariantIdentifier } ?? symbols.first
        }
        return symbols.first { $0.reference.variant == variant }
    }

    public init(named name: String) throws {

        guard
            let manifestURL = Bundle.sharedResourceURL?
                .appending(component: name)
                .appendingPathComponent("manifest.json")
        else {
            throw SymbolicError.missingManifest
        }
        let data = try Data(contentsOf: manifestURL)
        let manifest = try JSONDecoder().decode(Manifest.self, from: data)

        let variants = (manifest.variants ?? []).reduce(into: [String: Variant]()) { partialResult, variant in
            partialResult[variant.id] = Variant(id: variant.id, name: variant.name)
        }

        let symbols: [Symbol] = manifest.symbols.flatMap { symbol -> [Symbol] in
            return symbol.variants.map { variant in
                let reference = SymbolReference(family: manifest.id, name: symbol.id, variant: variant.id)
                let displayVariant = variants[variant.id]

                switch variant.properties {
                case .svg(let properties):
                    let url = Bundle.sharedResourceURL?
                        .appendingPathComponent(name)
                        .appendingPathComponent(properties.path)
                    return Symbol(reference: reference,
                                  variant: displayVariant,
                                  name: symbol.name ?? symbol.id,
                                  format: .svg(url: url))
                case .symbol(let properties):
                    return Symbol(reference: reference,
                                  variant: displayVariant,
                                  name: properties.name,
                                  format: .symbol(minimumOperatingSystemVersion: properties.minimumOperatingSystemVersion.flatMap { OperatingSystemVersion(string: $0) },
                                                  renderingMode: properties.renderingMode))
                case .emoji(let properties):
                    return Symbol(reference: reference,
                                  variant: displayVariant,
                                  name: symbol.name ?? symbol.id,
                                  format: .emoji(character: properties.character,
                                                 minimumOperatingSystemVersion: properties.minimumOperatingSystemVersion.flatMap { OperatingSystemVersion(string: $0) }))
                }
            }
        }

        let licenseFileURL: URL?
        if let path = manifest.license.path {
            guard
                let fileURL = Bundle.sharedResourceURL?
                    .appendingPathComponent(name)
                    .appendingPathComponent(path)
            else {
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
