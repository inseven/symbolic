// Copyright (c) 2022 Jason Morley
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

struct ExportToolbar: CustomizableToolbarContent {

    let macOS_icons: [(CGFloat, Int)] = [

        (16, 1),
        (16, 2),

        (32, 1),
        (32, 2),

        (128, 1),
        (128, 2),

        (256, 1),
        (256, 2),

        (512, 1),
        (512, 2),

    ]

    let iOS_icons: [(CGFloat, Int)] = [

        (20, 1),
        (20, 2),
        (20, 3),

        (29, 1),
        (29, 2),
        (29, 3),

        (40, 1),
        (40, 2),
        (40, 3),

        (60, 2),
        (60, 3),

        (76, 1),
        (76, 2),

        (83.5, 2),

        (1024, 1),
    ]

    @Environment(\.showSavePanel) var showSavePanel

    var document: Icon

    @MainActor func saveSnapshot(for document: Icon, size: CGFloat, scale: Int = 1, shadow: Bool = true, directoryURL: URL) throws {
        let scaledSize = size * CGFloat(scale)
        let icon = IconView(icon: document, size: scaledSize, renderShadow: shadow, isShadowFlipped: true)
        guard let data = icon.snapshot() else {
            throw SymbolicError.exportFailure
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let sizeString = formatter.string(from: NSNumber(value: size)) else {
            throw SymbolicError.exportFailure
        }
        let scaleString = scale > 1 ? String(format: "@%dx", scale) : ""
        let url = directoryURL.appendingPathComponent("icon_\(sizeString)x\(sizeString)\(scaleString)", conformingTo: .png)
        try data.write(to: url)
    }

    @MainActor func saveMacSnapshot(for document: Icon, size: CGFloat, scale: Int = 1, shadow: Bool = true, directoryURL: URL) throws {
        let scaledSize = size * CGFloat(scale)
        let icon = MacIconView(icon: document, size: scaledSize, isShadowFlipped: true)
        guard let data = icon.snapshot() else {
            throw SymbolicError.exportFailure
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let sizeString = formatter.string(from: NSNumber(value: size)) else {
            throw SymbolicError.exportFailure
        }
        let scaleString = scale > 1 ? String(format: "@%dx", scale) : ""
        let url = directoryURL.appendingPathComponent("icon_\(sizeString)x\(sizeString)\(scaleString)", conformingTo: .png)
        try data.write(to: url)
    }

    var body: some CustomizableToolbarContent {

        ToolbarItem(id: "export") {
            Button {
                // We're dispatching to main here because for some reason the compiler doens't think the button action
                // is being performed on MainActor and is giving warnings (which is surprising).
                DispatchQueue.main.async {
                    guard let url = showSavePanel("Export Icon") else {
                        return
                    }
                    do {
                        let macOSUrl = url.appendingPathComponent("macOS.iconset", conformingTo: .directory)
                        let iOSUrl = url.appendingPathComponent("iOS", conformingTo: .directory)

                        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                        try FileManager.default.createDirectory(at: macOSUrl, withIntermediateDirectories: true)
                        try FileManager.default.createDirectory(at: iOSUrl, withIntermediateDirectories: true)

                        // macOS
                        try saveSnapshot(for: document, size: 1024, directoryURL: url)
                        for (size, scale) in macOS_icons {
                            try saveMacSnapshot(for: document, size: size, scale: scale, directoryURL: macOSUrl)
                        }

                        // iOS
                        for (size, scale) in iOS_icons {
                            try saveSnapshot(for: document, size: size, scale: scale, shadow: false, directoryURL: iOSUrl)
                        }

                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.absoluteString)

                    } catch {
                        print("Failed to write to file with error \(error)")
                    }
                }
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
        }

    }

}
