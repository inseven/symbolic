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

import SwiftUI

struct MacGridView: View {

    var size: CGFloat

    static let contentScale = 0.8046875
    static let marginBisectorRatio = 0.048828125

    var body: some View {
        let contentSize = size * Self.contentScale
        let contentOrigin = (size - contentSize) / 2
        let bisector = size * Self.marginBisectorRatio

        ZStack {
            Path { path in
                path.addRect(CGRect(x: 0, y: 0, width: size, height: size))
                path.addRoundedRect(in: CGRect(x: contentOrigin, y: contentOrigin, width: contentSize, height: contentSize),
                                     cornerSize: CGSize(width: contentSize * AppGridView.cornerRadiusRatio,
                                                         height: contentSize * AppGridView.cornerRadiusRatio),
                                     style: .continuous)
            }
            .fill(Color.blue.opacity(0.4), style: FillStyle(eoFill: true))

            Path { path in
                path.addRect(CGRect(x: 0, y: 0, width: size, height: size))
                path.addRect(CGRect(x: bisector, y: bisector, width: size - 2 * bisector, height: size - 2 * bisector))
            }
            .stroke(Color.blue, lineWidth: 1)

            AppGridView(size: contentSize, cornerStyle: .continuous)
        }
        .frame(width: size, height: size)
    }

}
