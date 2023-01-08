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

struct WatchGridView: View {

    var size: CGFloat

    static let scale1 = 256.0 / 1024.0
    static let scale2 = 541.87 / 1024.0
    static let scale3 = 768.0 / 1024.0

    var radius1: CGFloat {
        return size * Self.scale1
    }

    var radius2: CGFloat {
        return size * Self.scale2
    }

    var radius3: CGFloat {
        return size * Self.scale3
    }

    var radius4: CGFloat {
        return size
    }

    var body: some View {

        ZStack {
            Path() { path in
                path.move(to: CGPoint(x: size / 2, y: 0))
                path.addLine(to: CGPoint(x: size / 2, y: size))
                path.move(to: CGPoint(x: 0, y: size / 2))
                path.addLine(to: CGPoint(x: size, y: size / 2))
            }
            .stroke(lineWidth: 1)
            .frame(width: size, height: size)
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: radius1, height: radius1)
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: radius2, height: radius2)
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: radius3, height: radius3)
            Circle()
                .stroke(lineWidth: 1)
                .frame(width: radius4, height: radius4)
        }
        .foregroundColor(.blue)
    }

}
