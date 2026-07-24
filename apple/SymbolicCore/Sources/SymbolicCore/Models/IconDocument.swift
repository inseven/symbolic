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
import UniformTypeIdentifiers

public final class IconDocument: ReferenceFileDocument {

    public typealias Snapshot = Icon

    @Published public var icon: Icon

    public static var readableContentTypes: [UTType] { [.iconDocument] }

    public func snapshot(contentType: UTType) throws -> Snapshot {
        return icon
    }

    public init() {
        // Load the initial icon from the built-in template.
        let url = Bundle.module.url(forResource: "Template", withExtension: "symbolic")!
        let data = try! Data(contentsOf: url)
        icon = try! JSONDecoder().decode(Icon.self, from: data)
    }

    public init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.icon = try JSONDecoder().decode(Icon.self, from: data)
    }

    public func fileWrapper(snapshot: Icon, configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(snapshot)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }

    @MainActor public func export(destination url: URL) throws {


        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
        for section in IconSection.all {
            let directoryUrl = url.appendingPathComponent(section.directory, conformingTo: .directory)
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
            for iconSet in section.sets {
                for definition in iconSet.definitions {
                    _ = try icon.saveSnapshot(definition: definition, directoryURL: directoryUrl)
                }
            }
            try section.additionalFiles?(directoryUrl, icon)
        }
        if let licenseUrl = LibraryManager.shared.library(for: icon.symbol)?.license.fileURL {
            try FileManager.default.copyItem(at: licenseUrl, to: url.appendingPathComponent("LICENSE"))
        }
    }

}
