// Copyright (c) 2022-2025 Jason Morley
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

import XCTest
@testable import Symbolic

final class ExportTests: XCTestCase {

    func createTemporaryDirectory() throws -> URL {

        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        var isDirectory: ObjCBool = false
        XCTAssertTrue(fileManager.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory))
        XCTAssert(isDirectory.boolValue)

        addTeardownBlock {
            do {
                let fileManager = FileManager.default
                try fileManager.removeItem(at: directoryURL)
                XCTAssertFalse(fileManager.fileExists(atPath: directoryURL.path))
            } catch {
                XCTFail("Failed to delete temporary directory with error '\(error)'.")
            }
        }

        return directoryURL
    }

    func testMaterialIconsExpectedFiles() async throws {

        let directoryURL = try createTemporaryDirectory()
        let exportURL = directoryURL.appendingPathComponent("Export")

        let document = IconDocument()
        XCTAssertEqual(document.icon.symbol.family, "material-icons")
        try await document.export(destination: exportURL)

        XCTAssertDirectoryExists(exportURL)
        XCTAssertDirectoryExists(exportURL.appendingPathComponent("macOS.iconset"))
        XCTAssertDirectoryExists(exportURL.appendingPathComponent("iOS"))
        XCTAssertDirectoryExists(exportURL.appendingPathComponent("watchOS"))
        XCTAssertFileExists(exportURL.appendingPathComponent("LICENSE"))
    }

    func testSFSymbolsExpectedFiles() async throws {

        let directoryURL = try createTemporaryDirectory()
        let exportURL = directoryURL.appendingPathComponent("Export")

        let document = IconDocument()
        XCTAssertEqual(document.icon.symbol.family, "material-icons")
        document.icon.symbol = SymbolReference(family: "sf-symbols", name: "square.and.arrow.up", variant: nil)
        try await document.export(destination: exportURL)

        XCTAssertDirectoryExists(exportURL)
        XCTAssertDirectoryExists(exportURL.appendingPathComponent("macOS.iconset"))
        XCTAssertDirectoryExists(exportURL.appendingPathComponent("iOS"))
        XCTAssertDirectoryExists(exportURL.appendingPathComponent("watchOS"))
        XCTAssertNotFileExists(exportURL.appendingPathComponent("LICENSE"))
    }

    func testExportFailsMissingDirectory() async {

        let directoryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        let exportURL = directoryURL.appendingPathComponent("Export")

        let document = IconDocument()
        XCTAssertEqual(document.icon.symbol.family, "material-icons")

        do {
            try await document.export(destination: exportURL)
            XCTFail("Export succeeded unexpectedly.")
        } catch {
            XCTAssertError(error, domain: NSCocoaErrorDomain, code: NSFileNoSuchFileError)
        }
    }

    func testExportFailsMissingMaterialIconsSymbol() async throws {

        let directoryURL = try createTemporaryDirectory()
        let exportURL = directoryURL.appendingPathComponent("Export")

        let document = IconDocument()
        document.icon.symbol = SymbolReference(family: "material-icons", name: "heffalump", variant: "default")

        do {
            try await document.export(destination: exportURL)
            XCTFail("Export succeeded unexpectedly.")
        } catch {
            XCTAssertEqual(error as? SymbolicError, SymbolicError.unknownSymbol)
        }
    }

    func testExportFailsMissingSFSymbolsSymbol() async throws {

        let directoryURL = try createTemporaryDirectory()
        let exportURL = directoryURL.appendingPathComponent("Export")

        let document = IconDocument()
        document.icon.symbol = SymbolReference(family: "sf-symbols", name: "heffalump", variant: nil)

        do {
            try await document.export(destination: exportURL)
            XCTFail("Export succeeded unexpectedly.")
        } catch {
            XCTAssertEqual(error as? SymbolicError, SymbolicError.unknownSymbol)
        }
    }

}
