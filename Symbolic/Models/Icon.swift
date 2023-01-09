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
        case id = "id"
        case topColor = "topColor"
        case bottomColor = "bottomColor"
        case systemImage = "systemImage"
        case symbolColor = "symbolColor"
        case iconScale = "iconScale"
        case iconOffset = "iconOffset"
        case shadowOpacity = "shadowOpacity"
        case shadowHeight = "shadowHeight"
    }

    var id = UUID()

    var topColor: Color = .pink
    var bottomColor: Color = .purple

    var systemImage: String = "face.smiling"
    var symbolColor: Color = .white
    var iconScale: CGFloat = 0.8
    var iconOffset: CGSize = .zero

    var shadowOpacity: CGFloat = 0.4
    var shadowHeight: CGFloat = 0.3

    init() {
        
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.topColor = try container.decode(Color.self, forKey: .topColor)
        self.bottomColor = try container.decode(Color.self, forKey: .bottomColor)
        self.systemImage = try container.decode(String.self, forKey: .systemImage)
        self.symbolColor = try container.decode(Color.self, forKey: .symbolColor)
        self.iconScale = try container.decode(CGFloat.self, forKey: .iconScale)
        self.iconOffset = (try? container.decode(CGSize.self, forKey: .iconOffset)) ?? .zero
        self.shadowOpacity = try container.decode(CGFloat.self, forKey: .shadowOpacity)
        self.shadowHeight = try container.decode(CGFloat.self, forKey: .shadowHeight)
    }

}
