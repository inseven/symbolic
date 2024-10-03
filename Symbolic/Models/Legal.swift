// Copyright (c) 2022-2024 Jason Morley
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

import Foundation

import Diligence

struct Legal {
    
    static let actions: [Action] = {
        let title = "Symbolic Support (\(Bundle.main.version ?? "Unknown Version"))"
        return [
            Action("Website", url: URL(string: "https://symbolic.jbmorley.co.uk")!),
            Action("Privacy", url: URL(string: "https://symbolic.jbmorley.co.uk/privacy-policy")!),
            Action("GitHub", url: URL(string: "https://github.com/inseven/symbolic")!),
            Action("Support", url: URL(address: "support@jbmorley.co.uk", subject: title)!),
        ]
    }()
    
    static let contents = Contents(repository: "inseven/symbolic",
                                   copyright: "Copyright © 2022-2024 Jason Morley") {
        Self.actions
    } acknowledgements: {
        Acknowledgements("Developers") {
            Credit("Jason Morley", url: URL(string: "https://jbmorley.co.uk/about"))
        }
        Acknowledgements("Thanks") {
            Credit("Lukas Fittl")
            Credit("Michael Dales")
            Credit("Pavlos Vinieratos")
            Credit("Sarah Barbour")
            Credit("Simon Frost")
            Credit("Tom Sutcliffe")
        }
    } licenses: {
        LicenseGroup("Symbol Libraries") {
            for library in LibraryManager.shared.sets.filter({ $0.license.fileURL != nil }) {
                License(library.name, author: library.author, url: library.license.fileURL!)
            }
        }
        LicenseGroup("Licenses", includeDiligenceLicense: true) {
            .interact
            License("SwiftDraw", author: "Simon Whitty", filename: "swiftdraw-license")
            License("Symbolic", author: "Jason Morley", filename: "symbolic-license")
        }
    }
    
}
