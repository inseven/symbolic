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

import XCTest
@testable import Symbolic
@testable import SVGKit

final class SymbolicTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testLoadSymbols() throws {

        let symbolManager = SymbolManager.shared

        var count = 0
        for symbolSet in symbolManager.sets {
            for symbol in symbolSet.symbols {
                if symbol.format == .svg, let url = symbol.url {
                    let image = SVGKImage(contentsOf: url)
                    XCTAssertNotNil(image)
                    image?.size = CGSize(width: 1024, height: 1024)
                    XCTAssertNotNil(image?.nsImage)
                    count = count + 1
                }
            }
        }

        XCTAssertEqual(count, 10751)

    }

    func testLoadCachedSymbols() {

        let symbolManager = SymbolManager.shared

        var count = 0
        for symbolSet in symbolManager.sets {
            for symbol in symbolSet.symbols {
                if symbol.format == .svg, let url = symbol.url {
                    XCTAssertNotNil(SVGImage(url: url).cacheVectorGraphics(true))
                    count = count + 1
                }
            }
        }

        XCTAssertEqual(count, 10751)
    }

}
