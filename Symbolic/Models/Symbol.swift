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
    let variant: Variant?
    let name: String
    let format: Format
    let url: URL?

    var localizedDescription: String {
        guard let variant = variant else {
            return name
        }
        return "\(name) (\(variant.name))"
    }

    init(reference: SymbolReference, variant: Variant? = nil, name: String, format: Format, url: URL? = nil) {
        self.reference = reference
        self.variant = variant
        self.name = name
        self.format = format
        self.url = url
    }

}
