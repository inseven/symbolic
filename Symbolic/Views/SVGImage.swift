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

import SwiftDraw

private struct CacheVectorGraphics: EnvironmentKey {

    static let defaultValue = false

}

extension EnvironmentValues {

    var cacheVectorGraphics: Bool {
        get { self[CacheVectorGraphics.self] }
        set { self[CacheVectorGraphics.self] = newValue }
    }

}

extension View {

    func cacheVectorGraphics(_ cacheVectorGraphics: Bool) -> some View {
        return environment(\.cacheVectorGraphics, cacheVectorGraphics)
    }

}

struct SVGImage: View {

    @MainActor static var cache: NSCache<NSURL, NSImage> = NSCache()

    @Environment(\.cacheVectorGraphics) var cacheVectorGraphics

    let url: URL

    func image(for size: CGSize) -> NSImage? {
        guard !CGRect(origin: .zero, size: size).isEmpty else {
            return nil
        }
        guard let svg = SVG(fileURL: url) else {
            return nil
        }
        return svg.rasterize(with: size)
    }

    // Return an image representing the SVG.
    // If the cache is active, the image may be different to the preferred size; if not, the image will be rendered for
    // the requested size.
    @MainActor func image(preferredSize: CGSize) -> NSImage? {
        if cacheVectorGraphics,
           let image = Self.cache.object(forKey: url as NSURL) {
            return image
        }
        guard let image = self.image(for: cacheVectorGraphics ? CGSize(width: 1024, height: 1024) : preferredSize) else {
            return nil
        }
        if cacheVectorGraphics {
            Self.cache.setObject(image, forKey: url as NSURL)
        }
        return image
    }

    var body: some View {
        GeometryReader { geometry in
            if let image = image(preferredSize: geometry.size) {
                Image(nsImage: image)
                    .renderingMode(.template)
                    .resizable()
            } else {
                EmptyView()
            }
        }
    }

}
