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

import Diligence
import Interact

import SymbolicCore

#if canImport(Sparkle)
import Sparkle
#endif

class ApplicationModel: NSObject, ObservableObject {

    let settings = Settings()

#if canImport(Glitter)
    let updaterController = SPUStandardUpdaterController(startingUpdater: false,
                                                         updaterDelegate: nil,
                                                         userDriverDelegate: nil)
#else
    private let storeUpdateChecker = StoreUpdateChecker(url: URL(string: "https://symbolic.jbmorley.co.uk/current.json")!)
#endif

    @MainActor override init() {
        super.init()
#if !canImport(Glitter)
        storeUpdateChecker.delegate = self
#endif
        self.start()
    }

    @MainActor func start() {

#if canImport(Glitter) && !DEBUG
        updaterController.startUpdater()
#endif

#if !canImport(Glitter)
        if !settings.suppressUpdateCheck {
            storeUpdateChecker.check()
        }
#endif
    }

    @MainActor private lazy var aboutWindow: NSWindow = {
        return NSWindow(Legal.contents)
    }()

    @MainActor func showAbout() {

        // TODO: Selecting text when the color picker is open sets the color to black #177
        //       https://github.com/inseven/symbolic/issues/177
        // The SwiftUI color picker has a curious bug where it assigns black to the currently focused color if the user
        // taps on a selectable area of text. Since we can't disable text selection in the alerts that may be presented
        // during this flow, we simply dismiss the picker. We should revisit this in a later SwiftUI release and see if
        // it's been fixed.
        NSApplication.shared.closeColorPanels()

        NSApplication.shared.activate(ignoringOtherApps: true)
        if !aboutWindow.isVisible {
            // Size the window to its SwiftUI content before centering; otherwise the hosting controller resizes it
            // after `center()` has run and it ends up off-centre.
            if let contentView = aboutWindow.contentViewController?.view {
                aboutWindow.setContentSize(contentView.fittingSize)
            }
            aboutWindow.center()
        }
        aboutWindow.makeKeyAndOrderFront(nil)
    }

}

extension ApplicationModel: StoreUpdateCheckerDelegate {

    @MainActor func storeUpdateChecker(_ storeUpdateChecker: StoreUpdateChecker,
                                       didDismissAlertWithSuppressionState suppressionState: Bool) {
        settings.suppressUpdateCheck = suppressionState
    }

}
