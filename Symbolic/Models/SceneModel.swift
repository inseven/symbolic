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

import Combine
import SwiftUI

import Interact

class SceneModel: ObservableObject, Runnable {

    var settings: Settings
    var document: IconDocument

    @Published var library: Library? = nil
    @Published var showGrid = false
    @Published var showOffsetX = false
    @Published var showOffsetY = false
    @Published var showExportWarning = false
    @Published var showExportPanel = false
    @Published var lastError: Error?

    @MainActor private var cancellables: Set<AnyCancellable> = []

    init(settings: Settings, document: IconDocument) {
        self.settings = settings
        self.document = document
    }

    @MainActor func start() {
        document.$icon
            .receive(on: DispatchQueue.main)
            .map { icon in
                return LibraryManager.shared.library(for: icon.symbol)
            }
            .sink { [weak self] library in
                guard let self else { return }
                self.library = library
            }
            .store(in: &cancellables)
    }

    @MainActor func stop() {
        cancellables.removeAll()
    }

    @MainActor func export() {

        // TODO: Selecting text when the color picker is open sets the color to black #177
        //       https://github.com/inseven/symbolic/issues/177
        // The SwiftUI color picker has a curious bug where it assigns black to the currently focused color if the user
        // taps on a selectable area of text. Since we can't disable text selection in the alerts that may be presented
        // during this flow, we simply dismiss the picker. We should revisit this in a later SwiftUI release and see if
        // it's been fixed.
        NSApplication.shared.closeColorPanels()

        if library?.warning != nil {
            showExportWarning = true
        } else {
            showExportPanel = true
        }
    }

    @MainActor func cancelExport() {
        showExportWarning = false
        showExportPanel = false
    }

    @MainActor func continueExport() {
        showExportWarning = false
        DispatchQueue.main.async {
            self.showExportPanel = true
        }
    }

    @MainActor func export(destination url: URL) {
        do {
            try document.export(destination: url)
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.absoluteString)
        } catch {
            self.lastError = error
        }
    }

}
