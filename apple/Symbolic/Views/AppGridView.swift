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

import SymbolicCore

struct AppGridView: View {

    var size: CGFloat
    var cornerStyle: RoundedCornerStyle

    static let cornerRadiusRatio = 0.2233009709
    static let circle1Scale = 383.0 / 1024.0
    static let circle2Scale = 541.0 / 1024.0
    static let circle3Scale = 888.0 / 1024.0

    var body: some View {
        let center = CGPoint(x: size / 2, y: size / 2)
        let radius1 = size * Self.circle1Scale / 2
        let radius2 = size * Self.circle2Scale / 2
        let radius3 = size * Self.circle3Scale / 2
        let margin = size / 2 - radius3
        let innerGrid = size / 2 - radius1

        ZStack {
            Path { path in
                for x in [margin, innerGrid, size / 2, size - innerGrid, size - margin] {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size))
                }
                for y in [margin, innerGrid, size / 2, size - innerGrid, size - margin] {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size, y: y))
                }

                path.move(to: CGPoint(x: margin, y: margin))
                path.addLine(to: CGPoint(x: size - margin, y: size - margin))
                path.move(to: CGPoint(x: margin, y: size - margin))
                path.addLine(to: CGPoint(x: size - margin, y: margin))

                path.addCircle(center: center, radius: radius1)
                path.addCircle(center: center, radius: radius2)
                path.addCircle(center: center, radius: radius3)

                path.addRoundedRect(in: CGRect(x: 0, y: 0, width: size, height: size),
                                     cornerSize: CGSize(width: size * Self.cornerRadiusRatio,
                                                         height: size * Self.cornerRadiusRatio),
                                     style: cornerStyle)
            }
            .stroke(lineWidth: 1)
        }
        .foregroundColor(.blue)
        .frame(width: size, height: size)
    }

}
