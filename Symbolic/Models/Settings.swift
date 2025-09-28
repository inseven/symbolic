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

import SwiftUI

import Interact

extension UserDefaults {

    func bool(forKey defaultName: String, defaultValue: Bool) -> Bool {
        if object(forKey: defaultName) == nil {
            return defaultValue
        }
        return bool(forKey: defaultName)
    }

}

public class Settings: ObservableObject {

    enum Key: String {
        case showIconDetails = "showIconDetails"
        case suppressUpdateCheck
    }

    @Published public var showIconDetails: Bool {
        didSet {
            keyedDefaults.set(showIconDetails, forKey: .showIconDetails)
        }
    }

    @Published public var suppressUpdateCheck: Bool {
        didSet {
            keyedDefaults.set(suppressUpdateCheck, forKey: .suppressUpdateCheck)
        }
    }

    private let keyedDefaults = KeyedDefaults<Key>()

    public init() {
        showIconDetails = keyedDefaults.bool(forKey: .showIconDetails, default: false)
        suppressUpdateCheck = keyedDefaults.bool(forKey: .suppressUpdateCheck, default: false)
    }

}
