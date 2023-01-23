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

import SwiftUI

struct Icon: Identifiable, Codable {

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case id = "id"
        case topColor = "topColor"
        case bottomColor = "bottomColor"
        case systemImage = "systemImage"
        case symbol = "symbol"
        case symbolColor = "symbolColor"
        case iconScale = "iconScale"
        case iconOffset = "iconOffset"
        case shadowOpacity = "shadowOpacity"
        case shadowHeight = "shadowHeight"
    }

    var id = UUID()

    var topColor: Color = .pink
    var bottomColor: Color = .purple

    var symbol: SymbolReference = SymbolReference(family: "sf-symbols", name: "face.smiling", variant: nil)
    var symbolColor: Color = .white
    var iconScale: CGFloat = 0.8
    var iconOffset: CGSize = .zero

    var shadowOpacity: CGFloat = 0.4
    var shadowHeight: CGFloat = 0.3

    init() {
        
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let version = (try? container.decode(Int.self, forKey: .version)) ?? 0
        switch version {
        case 0:
            self.id = try container.decode(UUID.self, forKey: .id)
            self.topColor = try container.decode(Color.self, forKey: .topColor)
            self.bottomColor = try container.decode(Color.self, forKey: .bottomColor)
            let systemImage = try container.decode(String.self, forKey: .systemImage)
            self.symbol = SymbolReference(family: "sf-symbols", name: systemImage, variant: nil)
            self.symbolColor = try container.decode(Color.self, forKey: .symbolColor)
            self.iconScale = try container.decode(CGFloat.self, forKey: .iconScale)
            self.iconOffset = (try? container.decode(CGSize.self, forKey: .iconOffset)) ?? .zero
            self.shadowOpacity = try container.decode(CGFloat.self, forKey: .shadowOpacity)
            self.shadowHeight = try container.decode(CGFloat.self, forKey: .shadowHeight)
        case 1:
            self.id = try container.decode(UUID.self, forKey: .id)
            self.topColor = try container.decode(Color.self, forKey: .topColor)
            self.bottomColor = try container.decode(Color.self, forKey: .bottomColor)
            self.symbol = try container.decode(SymbolReference.self, forKey: .symbol)
            self.symbolColor = try container.decode(Color.self, forKey: .symbolColor)
            self.iconScale = try container.decode(CGFloat.self, forKey: .iconScale)
            self.iconOffset = (try? container.decode(CGSize.self, forKey: .iconOffset)) ?? .zero
            self.shadowOpacity = try container.decode(CGFloat.self, forKey: .shadowOpacity)
            self.shadowHeight = try container.decode(CGFloat.self, forKey: .shadowHeight)
        default:
            throw SymbolicError.unsupportedVersion
        }

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(1, forKey: .version)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.topColor, forKey: .topColor)
        try container.encode(self.bottomColor, forKey: .bottomColor)
        try container.encode(self.symbol, forKey: .symbol)
        try container.encode(self.symbolColor, forKey: .symbolColor)
        try container.encode(self.iconScale, forKey: .iconScale)
        try container.encode(self.iconOffset, forKey: .iconOffset)
        try container.encode(self.shadowOpacity, forKey: .shadowOpacity)
        try container.encode(self.shadowHeight, forKey: .shadowHeight)
    }

}
