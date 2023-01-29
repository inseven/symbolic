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

struct IconView: View {

    struct Constants {
        static let shadowOffsetScaleFactor = 0.125
    }

    var icon: Icon
    var size: CGFloat
    var renderShadow: Bool = true
    var isShadowFlipped = false
    var isWatchOS = false

    var iconSize: CGFloat {
        if isWatchOS {
            return size * icon.iconScale * (768.0 / 890.0)
        } else {
            return size * icon.iconScale
        }
    }

    var iconOffset: CGSize {
        return CGSize(width: icon.iconOffset.width * size,
                      height: icon.iconOffset.height * size * -1.0)
    }

    var body: some View {
        ZStack {
            let x = size / 2
            let y = size / 2
            let shadowRadius = size * icon.shadowHeight * Constants.shadowOffsetScaleFactor
            let shadowOffset = size * icon.shadowHeight * Constants.shadowOffsetScaleFactor * (isShadowFlipped ? -1.0 : 1.0)

            LinearGradient(gradient: Gradient(colors: [icon.topColor, icon.bottomColor]),
                           startPoint: .top,
                           endPoint: .bottom)

            let image = SymbolView(symbolReference: icon.symbol)
                .foregroundColor(icon.symbolColor)

            VStack {
                if renderShadow {
                    image
                        .shadow(color: .black.opacity(icon.shadowOpacity),
                                radius: shadowRadius,
                                x: 0,
                                y: shadowOffset)
                        .offset(iconOffset)
                } else {
                    image
                        .offset(iconOffset)
                }
            }
            .frame(width: iconSize, height: iconSize)
            .position(x: x, y: y)
        }
        .frame(width: size, height: size)
    }

}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(icon: Icon(), size: 512)
    }
}
