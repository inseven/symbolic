// Copyright (c) 2022-2024 Jason Morley
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
import UniformTypeIdentifiers

final class IconDocument: ReferenceFileDocument {

    typealias Snapshot = Icon

    @Published var icon: Icon

    static var readableContentTypes: [UTType] { [.iconDocument] }

    func snapshot(contentType: UTType) throws -> Snapshot {
        return icon
    }

    init() {
        // Load the initial icon from the built-in template.
        let url = Bundle.main.url(forResource: "Template", withExtension: "symbolic")!
        let data = try! Data(contentsOf: url)
        icon = try! JSONDecoder().decode(Icon.self, from: data)
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.icon = try JSONDecoder().decode(Icon.self, from: data)
    }

    func fileWrapper(snapshot: Icon, configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }

    @MainActor func export(destination url: URL) throws {

        // Check that the symbol exists.
        guard LibraryManager.shared.symbol(for: icon.symbol) != nil else {
            throw SymbolicError.unknownSymbol
        }

        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        for section in ApplicationModel.icons {
            for iconSet in section.sets {
                let directoryUrl = url.appendingPathComponent(section.directory, conformingTo: .directory)
                try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
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
        if let licenseUrl = LibraryManager.shared.library(for: icon.symbol)?.license.fileURL {
            try FileManager.default.copyItem(at: licenseUrl, to: url.appendingPathComponent("LICENSE"))
        }
    }

}
