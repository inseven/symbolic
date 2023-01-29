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

import SwiftUI

import Diligence
import Interact

class ApplicationModel: ObservableObject {

    // https://developer.apple.com/design/human-interface-guidelines/foundations/app-icons/

    static let icons: [IconSection] = [

        IconSection("macOS", directory: "macOS.iconset") {

            IconSet("16pt") {
                IconDefinition(.macOS, size: 16, scale: 1)
                IconDefinition(.macOS, size: 16, scale: 2)
            }

            IconSet("32pt") {
                IconDefinition(.macOS, size: 32, scale: 1)
                IconDefinition(.macOS, size: 32, scale: 2)
            }

            IconSet("128pt") {
                IconDefinition(.macOS, size: 128, scale: 1)
                IconDefinition(.macOS, size: 128, scale: 2)
            }

            IconSet("256pt") {
                IconDefinition(.macOS, size: 256, scale: 1)
                IconDefinition(.macOS, size: 256, scale: 2)
            }

            IconSet("512pt") {
                IconDefinition(.macOS, size: 512, scale: 1)
                IconDefinition(.macOS, size: 512, scale: 2)
            }

            // App Store
            IconSet("App Store") {
                IconDefinition(.macOS, size: 1024, scale: 1)
            }

        },

        IconSection("iOS", directory: "iOS") {

            // iPhone
            IconSet("iPhone Notifications") {
                IconDefinition(.iOS, size: 20, scale: 2)
                IconDefinition(.iOS, size: 20, scale: 3)
            }
            IconSet("iPhone Settings") {
                IconDefinition(.iOS, size: 29, scale: 2)
                IconDefinition(.iOS, size: 29, scale: 3)
            }
            IconSet("iPhone Spotlight") {
                IconDefinition(.iOS, size: 40, scale: 2)
                IconDefinition(.iOS, size: 40, scale: 3)
            }
            IconSet("iPhone App") {
                IconDefinition(.iOS, size: 60, scale: 2)
                IconDefinition(.iOS, size: 60, scale: 3)
            }

            // iPad
            IconSet("iPad Notifications") {
                IconDefinition(.iOS, size: 20, scale: 1)
                IconDefinition(.iOS, size: 20, scale: 2)
            }
            IconSet("iPad Settings") {
                IconDefinition(.iOS, size: 29, scale: 1)
                IconDefinition(.iOS, size: 29, scale: 2)
            }
            IconSet("iPad Spotlight") {
                IconDefinition(.iOS, size: 40, scale: 1)
                IconDefinition(.iOS, size: 40, scale: 2)
            }

            IconSet("iPad App") {
                IconDefinition(.iOS, size: 76, scale: 1)
                IconDefinition(.iOS, size: 76, scale: 2)
            }
            IconSet("iPad Pro (12.9-inch) App") {
                IconDefinition(.iOS, size: 83.5, scale: 2)
                IconDefinition(.iOS, size: 83.5, scale: 3)
            }

            // App Store
            IconSet("App Store") {
                IconDefinition(.iOS, size: 1024, scale: 1)
            }

        },

        IconSection("watchOS", directory: "watchOS") {

            IconSet("Notification Center") {
                IconDefinition(.watchOS, size: 24, scale: 2)
                IconDefinition(.watchOS, size: 27.5, scale: 2)
                IconDefinition(.watchOS, size: 33, scale: 2)
            }

            IconSet("Companion Settings") {
                IconDefinition(.watchOS, size: 29, scale: 2)
                IconDefinition(.watchOS, size: 29, scale: 3)
            }

            IconSet("Home Screen") {
                IconDefinition(.watchOS, size: 40, scale: 2, description: "38mm")
                IconDefinition(.watchOS, size: 44, scale: 2, description: "40mm")
                IconDefinition(.watchOS, size: 46, scale: 2, description: "41mm")
                IconDefinition(.watchOS, size: 40, scale: 2, description: "42mm")
                IconDefinition(.watchOS, size: 50, scale: 2, description: "44mm")
                IconDefinition(.watchOS, size: 51, scale: 2, description: "45mm")
                IconDefinition(.watchOS, size: 54, scale: 2, description: "49mm")
            }

            IconSet("Short Look") {
                IconDefinition(.watchOS, size: 86, scale: 2, description: "38mm")
                IconDefinition(.watchOS, size: 98, scale: 2, description: "42mm")
                IconDefinition(.watchOS, size: 108, scale: 2, description: "44mm")
                IconDefinition(.watchOS, size: 117, scale: 2, description: "45mm")
                IconDefinition(.watchOS, size: 129, scale: 2, description: "49mm")
            }

            IconSet("App Store") {
                IconDefinition(.watchOS, size: 1024, scale: 1)
            }

        },

    ]

    let settings = Settings()

    @MainActor private lazy var aboutWindow: NSWindow = {
        return NSWindow(repository: "inseven/symbolic", copyright: "Copyright © 2022-2023 InSeven Limited") {
            Action("Website", url: URL(string: "https://symbolic.app")!)
            Action("Privacy", url: URL(string: "https://symbolic.app/privacy")!)
            Action("GitHub", url: URL(string: "https://github.com/inseven/symbolic")!)
            Action("InSeven Limited", url: URL(string: "https://inseven.co.uk")!)
        } acknowledgements: {
            Acknowledgements("Developers") {
                Credit("Jason Morley", url: URL(string: "https://jbmorley.co.uk"))
            }
            Acknowledgements("Thanks") {
                Credit("Lukas Fittl")
                Credit("Michael Dales")
                Credit("Pavlos Vinieratos")
                Credit("Sarah Barbour")
                Credit("Simon Frost")
            }
        } licenses: {

            License("Binding+mappedToBool", author: "Joseph Duffy", filename: "binding-mappedtobool-license")
            License("Interact", author: "InSeven Limited", url: Interact.Package.licenseURL)
            License("SwiftDraw", author: "Simon Whitty", filename: "swiftdraw-license")
            License("Symbolic", author: "InSeven Limited", filename: "symbolic-license")

            for library in LibraryManager.shared.sets.filter({ $0.license.fileURL != nil }) {
                License(library.name, author: library.author, url: library.license.fileURL!)
            }
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
