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
