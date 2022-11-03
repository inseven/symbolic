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
import UniformTypeIdentifiers

extension UTType {
    static let iconDocument = UTType(exportedAs: "uk.co.inseven.symbolic.icon")
}

final class IconDocument: ReferenceFileDocument {

    typealias Snapshot = Icon

    @Published var icon: Icon

    static var readableContentTypes: [UTType] { [.iconDocument] }

    func snapshot(contentType: UTType) throws -> Snapshot {
        return icon
    }

    init() {
        icon = Icon()
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

}

struct Icon: Identifiable, Codable {

    var id = UUID()

    var topColor: Color = .pink
    var bottomColor: Color = .purple

    var systemImage: String = "face.smiling"
    var symbolColor: Color = .white
    var iconScale: CGFloat = 0.8

    var shadowOpacity: CGFloat = 0.4
    var shadowHeight: CGFloat = 0.3

}
