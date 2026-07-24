// Copyright (c) 2022-2026 Jason Morley
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

// https://developer.apple.com/design/human-interface-guidelines/foundations/app-icons/
public extension IconSection {

    static let all: [IconSection] = [

        IconSection("macOS", directory: "macOS.iconset", additionalFiles: nil) {

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

        IconSection("iOS", directory: "iOS", additionalFiles: nil) {

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

        IconSection("watchOS", directory: "watchOS", additionalFiles: nil) {

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

        IconSection("Web", directory: "web", additionalFiles: { directoryURL, icon in
            try icon.writeFavicon(to: directoryURL, resolutions: [16, 32, 48])
        }) {

            IconSet("Favicon") {
                IconDefinition(.web, size: 16, scale: 1, description: "16", preferredBasename: "favicon-16x16")
                IconDefinition(.web, size: 32, scale: 1, description: "32", preferredBasename: "favicon-32x32")
                IconDefinition(.web, size: 48, scale: 1, description: "48", preferredBasename: "favicon-48x48")
            }

            IconSet("Apple Touch") {
                IconDefinition(.web, size: 180, scale: 1, description: "180", preferredBasename: "apple-touch-icon")
            }

            IconSet("Progressive Web App") {
                IconDefinition(.web, size: 192, scale: 1, description: "192", preferredBasename: "icon-192")
                IconDefinition(.web, size: 512, scale: 1, description: "512", preferredBasename: "icon-512")
            }

        }

    ]

}
