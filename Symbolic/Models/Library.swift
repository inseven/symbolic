// “Commons Clause” License Condition v1.0
// 
// The Software is provided to you by the Licensor under the License, as defined
// below, subject to the following condition.
// 
// Without limiting other conditions in the License, the grant of rights under the
// License will not include, and the License does not grant to you, the right to
// Sell the Software.
// 
// For purposes of the foregoing, “Sell” means practicing any or all of the rights
// granted to you under the License to provide to third parties, for a fee or other
// consideration (including without limitation fees for hosting or consulting/
// support services related to the Software), a product or service whose value
// derives, entirely or substantially, from the functionality of the Software. Any
// license notice or attribution required by the License must also include this
// Commons Clause License Condition notice.
// 
// Software: Symbolic
// License: BSD 3-Clause License
// Licensor: InSeven Limited
// 
// ---
// 
// BSD 3-Clause License
// 
// Copyright (c) 2022-2023 InSeven Limited
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

