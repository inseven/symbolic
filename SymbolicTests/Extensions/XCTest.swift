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

public func XCTAssertFileExists(_ url: URL,
                                _ message: @autoclosure () -> String = "",
                                file: StaticString = #filePath,
                                line: UInt = #line) {
    var isDirectory: ObjCBool = false
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
                  message(),
                  file: file,
                  line: line)
    XCTAssertFalse(isDirectory.boolValue, message(), file: file, line: line)
}

public func XCTAssertNotFileExists(_ url: URL,
                                _ message: @autoclosure () -> String = "",
                                file: StaticString = #filePath,
                                line: UInt = #line) {
    XCTAssertFalse(FileManager.default.fileExists(atPath: url.path), message(), file: file, line: line)
}


public func XCTAssertDirectoryExists(_ url: URL,
                                _ message: @autoclosure () -> String = "",
                                file: StaticString = #filePath,
                                line: UInt = #line) {
    var isDirectory: ObjCBool = false
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory),
                  message(),
                  file: file,
                  line: line)
    XCTAssertTrue(isDirectory.boolValue, message(), file: file, line: line)
}

public func XCTAssertError(_ error: Error,
                           domain: String,
                           code: Int,
                           _ message: @autoclosure () -> String = "",
                           file: StaticString = #filePath,
                           line: UInt = #line) {
    let nsError = error as NSError
    XCTAssertEqual(nsError.domain, domain, message(), file: file, line: line)
    XCTAssertEqual(nsError.code, code, message(), file: file, line: line)
}
