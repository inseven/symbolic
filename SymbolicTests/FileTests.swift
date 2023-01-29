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
