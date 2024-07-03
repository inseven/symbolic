// Copyright (c) 2022-2024 Jason Morley
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

struct IconView: View {

    struct Constants {
        static let shadowOffsetScaleFactor = 0.125
    }

    var icon: Icon
    var size: CGFloat
    var renderShadow: Bool = true
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
            let shadowOffset = size * icon.shadowHeight * Constants.shadowOffsetScaleFactor

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
