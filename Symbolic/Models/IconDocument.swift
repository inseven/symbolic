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
