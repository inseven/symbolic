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
@testable import SwiftDraw

final class LibraryTests: XCTestCase {

    func testLoadSymbols() throws {

        var count = 0
        for library in LibraryManager.shared.sets {
            for symbol in library.symbols {
                if case .svg(let url) = symbol.format, let url {
                    autoreleasepool {
                        let svg = SVG(fileURL: url)
                        XCTAssertNotNil(svg)
                        XCTAssertNotNil(svg?.rasterize(with: CGSize(width: 1024, height: 1024)))
                        count = count + 1
                    }
                }
            }
        }

        XCTAssertEqual(count, 10751)

    }

    func sfSymbol(named name: String) -> Symbol? {
        let reference = SymbolReference(family: "sf-symbols", name: name, variant: nil)
        return LibraryManager.shared.symbol(for: reference)
    }

    func testMaterializeCurrentName() throws {
        let symbol = try XCTUnwrap(sfSymbol(named: "square.and.arrow.up"))
        XCTAssertEqual(symbol.name, "square.and.arrow.up")
        guard case .symbol = symbol.format else {
            return XCTFail("Expected a symbol-format variant")
        }
    }

    func testMaterializeRenamedSymbols() throws {
        let renames = [
            "applelogo": "apple.logo",
            "doc": "document",
            "doc.fill": "document.fill",
            "snow": "snowflake",
            "homekit": "apple.homekit",
            "speaker.1.fill": "speaker.wave.1.fill",
        ]
        for (oldName, newName) in renames {
            let symbol = try XCTUnwrap(sfSymbol(named: oldName), "Failed to materialize '\(oldName)'")
            XCTAssertEqual(symbol.name, newName, "'\(oldName)' should resolve to '\(newName)'")
        }
    }

    func testMaterializeUnknownSymbolReturnsNil() {
        XCTAssertNil(sfSymbol(named: "heffalump"))
    }

    func testMinimumOperatingSystemVersion() throws {
        let original = try XCTUnwrap(sfSymbol(named: "square.and.arrow.up"))
        guard case .symbol(let originalVersion) = original.format else {
            return XCTFail("Expected a symbol-format variant")
        }
        XCTAssertEqual(originalVersion, OperatingSystemVersion(majorVersion: 10, minorVersion: 15, patchVersion: 0))

        let recent = try XCTUnwrap(sfSymbol(named: "blood.pressure.cuff.fill"))
        guard case .symbol(let recentVersion) = recent.format else {
            return XCTFail("Expected a symbol-format variant")
        }
        XCTAssertEqual(try XCTUnwrap(recentVersion).majorVersion, 26)
    }

    func testRenamedSymbolReportsMinimumOperatingSystemVersion() throws {
        let symbol = try XCTUnwrap(sfSymbol(named: "applelogo"))
        guard case .symbol(let version) = symbol.format else {
            return XCTFail("Expected a symbol-format variant")
        }
        XCTAssertEqual(version, OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0))
    }

    func testResolveSymbolAvailable() throws {
        // A variant-less reference resolves to the symbol's default variant.
        let reference = SymbolReference(family: "sf-symbols", name: "square.and.arrow.up", variant: nil)
        XCTAssertEqual(try LibraryManager.shared.resolveSymbol(for: reference),
                       SymbolReference(family: "sf-symbols", name: "square.and.arrow.up", variant: "default"))
    }

    func testResolveSymbolUpgradesRenamedName() throws {
        let reference = SymbolReference(family: "sf-symbols", name: "applelogo", variant: nil)
        XCTAssertEqual(try LibraryManager.shared.resolveSymbol(for: reference),
                       SymbolReference(family: "sf-symbols", name: "apple.logo", variant: "default"))
    }

    func testResolveSymbolUnknownSymbolThrows() {
        let reference = SymbolReference(family: "sf-symbols", name: "heffalump", variant: nil)
        XCTAssertThrowsError(try LibraryManager.shared.resolveSymbol(for: reference)) { error in
            XCTAssertEqual(error as? SymbolicError, .unknownSymbol)
        }
    }

}
