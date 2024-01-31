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

struct IconPreview: View {

    @ObservedObject var sceneModel: SceneModel

    let icon: Icon
    let definition: IconDefinition

    var body: some View {
        ZStack {

            let width = definition.size.width * (CGFloat(definition.scale) / 2)
            let height = definition.size.height * (CGFloat(definition.scale) / 2)

            switch definition.style {
            case .macOS:
                MacIconView(icon: icon, size: width, isShadowFlipped: false)
                if sceneModel.showGrid {
                    Image("Grid_macOS")
                        .resizable()
                        .frame(width: width, height: height)
                }
            case .iOS:
                IconView(icon: icon, size: width, renderShadow: false)
                    .modifier(IconCorners(size: width, style: .iOS))
                if sceneModel.showGrid {
                    Image("Grid_iOS")
                        .resizable()
                        .frame(width: width, height: height)
                }
            case .watchOS:
                IconView(icon: icon, size: width, renderShadow: false, isWatchOS: true)
                    .modifier(IconCorners(size: width, style: .watchOS))
                if sceneModel.showGrid {
                    WatchGridView(size: width)
                }
            }

            OffsetGuide(size: width, showX: sceneModel.showOffsetX, showY: sceneModel.showOffsetY)
        }
    }

}
