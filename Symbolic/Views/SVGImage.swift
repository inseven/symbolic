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
