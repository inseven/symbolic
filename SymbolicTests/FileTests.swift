// Copyright (c) 2022-2023 Jason Barrie Morley
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

final class FileTests: XCTestCase {

    var bundle: Bundle {
        return Bundle(for: Self.self)
    }

    func testLoadV0() throws {
        guard let url = bundle.url(forResource: "v0", withExtension: "symbolic") else {
            XCTFail("Failed to load test resource")
            return
        }

        let data = try Data(contentsOf: url)
        let icon = try JSONDecoder().decode(Icon.self, from: data)
        XCTAssertNotNil(icon)
        XCTAssertEqual(icon.symbol, SymbolReference(family: "sf-symbols", name: "suit.heart.fill", variant: nil))
    }

    func testLoadV1() throws {
        guard let url = bundle.url(forResource: "v1", withExtension: "symbolic") else {
            XCTFail("Failed to load test resource")
            return
        }

        let data = try Data(contentsOf: url)
        let icon = try JSONDecoder().decode(Icon.self, from: data)
        XCTAssertNotNil(icon)
        XCTAssertEqual(icon.symbol, SymbolReference(family: "material-icons", name: "favorite", variant: "default"))
    }

    func testLoadUnknownVersionFails() throws {
        guard let url = bundle.url(forResource: "v1000", withExtension: "symbolic") else {
            XCTFail("Failed to load test resource")
            return
        }

        let data = try Data(contentsOf: url)
        XCTAssertThrowsError(try JSONDecoder().decode(Icon.self, from: data)) { error in
            XCTAssertEqual(error as? SymbolicError, SymbolicError.unsupportedVersion)
        }
    }

}
