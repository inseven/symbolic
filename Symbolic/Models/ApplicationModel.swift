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

import SwiftUI

import Diligence
import Interact

class ApplicationModel: ObservableObject {

    @MainActor private lazy var aboutWindow: NSWindow = {
        return NSWindow(repository: "inseven/symbolic", copyright: "Copyright © 2022-2023 InSeven Limited") {
            Action("GitHub", url: URL(string: "https://github.com/inseven/symbolic")!)
            Action("InSeven Limited", url: URL(string: "https://inseven.co.uk")!)
        } acknowledgements: {
            Acknowledgements("Developers") {
                Credit("Jason Morley", url: URL(string: "https://jbmorley.co.uk"))
            }
            Acknowledgements("Thanks") {
                Credit("Sarah Barbour")
                Credit("Michael Dales")
            }
        } licenses: {
            License("Interact", author: "InSeven Limited", url: Interact.Package.licenseURL)
            License("Symbolic", author: "InSeven Limited", filename: "symbolic-license")
        }
    }()

    @MainActor func showAbout() {
        dispatchPrecondition(condition: .onQueue(.main))
        NSApplication.shared.activate(ignoringOtherApps: true)
        if !aboutWindow.isVisible {
            aboutWindow.center()
        }
        aboutWindow.makeKeyAndOrderFront(nil)
    }

}
