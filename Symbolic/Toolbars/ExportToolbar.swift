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

struct ExportToolbar: CustomizableToolbarContent {

    // https://developer.apple.com/design/human-interface-guidelines/foundations/app-icons/

    static let icons: [IconSection] = [

        IconSection("macOS", directory: "macOS.iconset") {

            IconSet("16pt") {
                IconDefinition(.macOS, size: 16, scale: 1)
                IconDefinition(.macOS, size: 16, scale: 2)
            }

            IconSet("32pt") {
                IconDefinition(.macOS, size: 32, scale: 1)
                IconDefinition(.macOS, size: 32, scale: 2)
            }

            IconSet("128pt") {
                IconDefinition(.macOS, size: 128, scale: 1)
                IconDefinition(.macOS, size: 128, scale: 2)
            }

            IconSet("256pt") {
                IconDefinition(.macOS, size: 256, scale: 1)
                IconDefinition(.macOS, size: 256, scale: 2)
            }
            
            IconSet("512pt") {
                IconDefinition(.macOS, size: 512, scale: 1)
                IconDefinition(.macOS, size: 512, scale: 2)
            }

            // App Store
            IconSet("App Store") {
                IconDefinition(.macOS, size: 1024, scale: 1)
            }

        },

        IconSection("iOS", directory: "iOS") {

            // iPhone
            IconSet("iPhone Notifications") {
                IconDefinition(.iOS, size: 20, scale: 2)
                IconDefinition(.iOS, size: 20, scale: 3)
            }
            IconSet("iPhone Settings") {
                IconDefinition(.iOS, size: 29, scale: 2)
                IconDefinition(.iOS, size: 29, scale: 3)
            }
            IconSet("iPhone Spotlight") {
                IconDefinition(.iOS, size: 40, scale: 2)
                IconDefinition(.iOS, size: 40, scale: 3)
            }
            IconSet("iPhone App") {
                IconDefinition(.iOS, size: 60, scale: 2)
                IconDefinition(.iOS, size: 60, scale: 3)
            }

            // iPad
            IconSet("iPad Notifications") {
                IconDefinition(.iOS, size: 20, scale: 1)
                IconDefinition(.iOS, size: 20, scale: 2)
            }
            IconSet("iPad Settings") {
                IconDefinition(.iOS, size: 29, scale: 1)
                IconDefinition(.iOS, size: 29, scale: 2)
            }
            IconSet("iPad Spotlight") {
                IconDefinition(.iOS, size: 40, scale: 1)
                IconDefinition(.iOS, size: 40, scale: 2)
            }
            
            IconSet("iPad App") {
                IconDefinition(.iOS, size: 76, scale: 1)
                IconDefinition(.iOS, size: 76, scale: 2)
            }
            IconSet("iPad Pro (12.9-inch) App") {
                IconDefinition(.iOS, size: 83.5, scale: 2)
                IconDefinition(.iOS, size: 83.5, scale: 3)
            }

            // App Store
            IconSet("App Store") {
                IconDefinition(.iOS, size: 1024, scale: 1)
            }

        },

        IconSection("watchOS", directory: "watchOS") {

            IconSet("Notification Center") {
                IconDefinition(.watchOS, size: 24, scale: 2)
                IconDefinition(.watchOS, size: 27.5, scale: 2)
                IconDefinition(.watchOS, size: 33, scale: 2)
            }

            IconSet("Companion Settings") {
                IconDefinition(.watchOS, size: 29, scale: 2)
                IconDefinition(.watchOS, size: 29, scale: 3)
            }

            IconSet("Home Screen") {
                IconDefinition(.watchOS, size: 40, scale: 2, description: "38mm")
                IconDefinition(.watchOS, size: 44, scale: 2, description: "40mm")
                IconDefinition(.watchOS, size: 46, scale: 2, description: "41mm")
                IconDefinition(.watchOS, size: 40, scale: 2, description: "42mm")
                IconDefinition(.watchOS, size: 50, scale: 2, description: "44mm")
                IconDefinition(.watchOS, size: 51, scale: 2, description: "45mm")
                IconDefinition(.watchOS, size: 54, scale: 2, description: "49mm")
            }

            IconSet("Short Look") {
                IconDefinition(.watchOS, size: 86, scale: 2, description: "38mm")
                IconDefinition(.watchOS, size: 98, scale: 2, description: "42mm")
                IconDefinition(.watchOS, size: 108, scale: 2, description: "44mm")
                IconDefinition(.watchOS, size: 117, scale: 2, description: "45mm")
                IconDefinition(.watchOS, size: 129, scale: 2, description: "49mm")
            }

            IconSet("App Store") {
                IconDefinition(.watchOS, size: 1024, scale: 1)
            }

        },

    ]

    @Environment(\.showSavePanel) var showSavePanel

    var document: Icon

    @MainActor func saveSnapshot(for document: Icon,
                                 size: CGFloat,
                                 scale: Int = 1,
                                 shadow: Bool = true,
                                 directoryURL: URL) throws {
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

    @MainActor func saveMacSnapshot(for document: Icon,
                                    size: CGFloat,
                                    scale: Int = 1,
                                    shadow: Bool = true,
                                    directoryURL: URL) throws {
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
                        let watchOSUrl = url.appendingPathComponent("watchOS", conformingTo: .directory)

                        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                        try FileManager.default.createDirectory(at: macOSUrl, withIntermediateDirectories: true)
                        try FileManager.default.createDirectory(at: iOSUrl, withIntermediateDirectories: true)
                        try FileManager.default.createDirectory(at: watchOSUrl, withIntermediateDirectories: true)

                        for section in ExportToolbar.icons {
                            for iconSet in section.sets {
                                let directoryUrl = url.appendingPathComponent(section.directory,
                                                                              conformingTo: .directory)
                                try FileManager.default.createDirectory(at: directoryUrl,
                                                                        withIntermediateDirectories: true)
                                for definition in iconSet.definitions {
                                    switch definition.style {
                                    case .macOS:
                                        try saveMacSnapshot(for: document,
                                                            size: definition.size.width,
                                                            scale: definition.scale,
                                                            directoryURL: directoryUrl)
                                    case .iOS, .watchOS:
                                        try saveSnapshot(for: document,
                                                         size: definition.size.width,
                                                         scale: definition.scale,
                                                         shadow: false,
                                                         directoryURL: directoryUrl)
                                    }
                                }
                            }
                        }

                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.absoluteString)

                    } catch {
                        print("Failed to write to file with error \(error)")
                    }
                }
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .help("Export icons")
        }

    }

}
