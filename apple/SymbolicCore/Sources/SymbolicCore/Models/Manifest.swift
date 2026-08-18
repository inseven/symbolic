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

struct Manifest: Codable {

    struct Variant: Codable {

        enum Properties {
            case svg(SVGProperties)
            case symbol(SymbolProperties)
        }

        struct SVGProperties: Codable {
            let path: String
        }

        struct SymbolProperties: Codable {
            let name: String
            let minimumOperatingSystemVersion: String?
            let renderingMode: RenderingMode
        }

        private enum Format: String, Codable {
            case svg
            case symbol
        }

        private enum CodingKeys: String, CodingKey {
            case id
            case format
            case properties
        }

        let id: String
        let properties: Properties

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            switch try container.decode(Format.self, forKey: .format) {
            case .svg:
                self.properties = .svg(try container.decode(SVGProperties.self, forKey: .properties))
            case .symbol:
                self.properties = .symbol(try container.decode(SymbolProperties.self, forKey: .properties))
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            switch properties {
            case .svg(let properties):
                try container.encode(Format.svg, forKey: .format)
                try container.encode(properties, forKey: .properties)
            case .symbol(let properties):
                try container.encode(Format.symbol, forKey: .format)
                try container.encode(properties, forKey: .properties)
            }
        }

    }

    struct VariantDefinition: Codable {
        let id: String
        let name: String
    }

    struct Symbol: Codable {
        let id: String
        let name: String?
        let variants: [Variant]
    }

    struct License: Codable {
        let name: String
        let path: String?
        let url: URL?
    }

    let id: String
    let name: String
    let author: String
    let url: URL?
    let license: License
    let variants: [VariantDefinition]?
    let symbols: [Symbol]
    let aliases: [String: String]?
    let warning: String?

}
