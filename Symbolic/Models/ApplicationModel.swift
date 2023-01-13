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

import Diligence
import Interact

class ApplicationModel: ObservableObject {

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

    @MainActor static func showSavePanel(_ title: String) -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.directory]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = title
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }

    @MainActor private lazy var aboutWindow: NSWindow = {
        return NSWindow(repository: "inseven/symbolic", copyright: "Copyright © 2022-2023 InSeven Limited") {
            Action("Website", url: URL(string: "https://symbolic.app")!)
            Action("Privacy", url: URL(string: "https://symbolic.app/privacy")!)
            Action("GitHub", url: URL(string: "https://github.com/inseven/symbolic")!)
            Action("InSeven Limited", url: URL(string: "https://inseven.co.uk")!)
        } acknowledgements: {
            Acknowledgements("Developers") {
                Credit("Jason Morley", url: URL(string: "https://jbmorley.co.uk"))
            }
            Acknowledgements("Thanks") {
                Credit("Lukas Fittl")
                Credit("Michael Dales")
                Credit("Pavlos Vinieratos")
                Credit("Sarah Barbour")
                Credit("Simon Frost")
            }
        } licenses: {

            License("Interact", author: "InSeven Limited", url: Interact.Package.licenseURL)
            License("Symbolic", author: "InSeven Limited", filename: "symbolic-license")
            License("SVGKit", author: "Matt Rajca, Various Authors, Tipbit Inc", filename: "svgkit-license")

            for symbolSet in SymbolManager.shared.sets.filter({ $0.licenseUrl != nil }) {
                License(symbolSet.name, author: symbolSet.author, url: symbolSet.licenseUrl!)
            }
        }
    }()

    @MainActor func showAbout() {
        dispatchPrecondition(condition: .onQueue(.main))
        NSApplication.shared.activate(ignoringOtherApps: true)
        if !aboutWindow.isVisible {
            aboutWindow.center()
        }
        aboutWindow.makeKeyAndOrderFront(nil)
    }

    @MainActor func export(icon: Icon) {
        guard let url = Self.showSavePanel("Export Icon") else {
            return
        }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            for section in Self.icons {
                for iconSet in section.sets {
                    let directoryUrl = url.appendingPathComponent(section.directory,
                                                                  conformingTo: .directory)
                    try FileManager.default.createDirectory(at: directoryUrl,
                                                            withIntermediateDirectories: true)
                    for definition in iconSet.definitions {
                        switch definition.style {
                        case .macOS:
                            try icon.saveMacSnapshot(size: definition.size.width,
                                                     scale: definition.scale,
                                                     directoryURL: directoryUrl)
                        case .iOS:
                            try icon.saveSnapshot(size: definition.size.width,
                                                  scale: definition.scale,
                                                  shadow: false,
                                                  directoryURL: directoryUrl)
                        case .watchOS:
                            try icon.saveSnapshot(size: definition.size.width,
                                                  scale: definition.scale,
                                                  shadow: false,
                                                  isWatchOS: true,
                                                  directoryURL: directoryUrl)
                        }
                    }
                }
            }
            if let licenseUrl = SymbolManager.shared.set(for: icon.symbol)?.licenseUrl {
                try FileManager.default.copyItem(at: licenseUrl, to: url.appendingPathComponent("LICENSE"))
            }

            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.absoluteString)

        } catch {
            print("Failed to write to file with error \(error)")
        }

    }

}
