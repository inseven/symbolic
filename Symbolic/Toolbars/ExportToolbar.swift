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

import SwiftUI

struct ExportToolbar: CustomizableToolbarContent {

    @FocusedObject private var sceneModel: SceneModel?

    var body: some CustomizableToolbarContent {

        ToolbarItem(id: "export") {
            Button {
                // We're dispatching to main here because for some reason the compiler doens't think the button action
                // is being performed on MainActor and is giving warnings (which is surprising).
                DispatchQueue.main.async {
                    sceneModel?.export()
                }
            } label: {
                Label("Export", systemImage: "square.and.arrow.up")
            }
            .help("Export icons")
            .requiresSubscription(groupID: ApplicationModel.subscriptionGroupID)
        }

    }

}
