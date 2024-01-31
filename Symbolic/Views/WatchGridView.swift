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

import SwiftUI

struct WatchGridView: View {

    var size: CGFloat

    static let scale1 = 256.0 / 1024.0
    static let scale2 = 541.87 / 1024.0
    static let scale3 = 768.0 / 1024.0

    let radius1: CGFloat
    let radius2: CGFloat
    let radius3: CGFloat
    let radius4: CGFloat
    let center: CGPoint

    init(size: CGFloat) {
        self.size = size
        self.radius1 = size * Self.scale1 / 2
        self.radius2 = size * Self.scale2 / 2
        self.radius3 = size * Self.scale3 / 2
        self.radius4 = size / 2
        self.center = CGPoint(x: size / 2, y: size / 2)
    }

    var body: some View {

        ZStack {
            Path() { path in
                path.move(to: CGPoint(x: size / 2, y: 0))
                path.addLine(to: CGPoint(x: size / 2, y: size))
                path.move(to: CGPoint(x: 0, y: size / 2))
                path.addLine(to: CGPoint(x: size, y: size / 2))
                path.addCircle(center: center, radius: radius1)
                path.addCircle(center: center, radius: radius2)
                path.addCircle(center: center, radius: radius3)
                path.addCircle(center: center, radius: radius4)
            }
            .stroke(lineWidth: 1)
        }
        .foregroundColor(.blue)
        .frame(width: size, height: size)
    }

}
