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
