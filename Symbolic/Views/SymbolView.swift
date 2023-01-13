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

struct SymbolView: View {

    let symbol: Symbol

    var body: some View {
        HStack {
            switch symbol.set {
            case .sfSymbols:
                Image(systemName: symbol.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .materialDesign:
                SVGImage(url: Bundle.main.url(forResource: symbol.name, withExtension: "svg", subdirectory: "Material Design")!)
            case .emoji:
                HStack {
                    Text(symbol.name)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 1024))
                        .minimumScaleFactor(0.001)
                }
            }
        }
    }

}
