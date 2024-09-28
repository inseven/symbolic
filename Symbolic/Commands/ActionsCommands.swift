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

import Diligence

struct ActionsCommands: Commands {
    
    enum Placement {
        case after(CommandGroupPlacement)
        case replacing(CommandGroupPlacement)
    }
    
    @Environment(\.openURL) private var openURL
    
    let placement: Placement
    let actions: [Action]
    
    init(after: CommandGroupPlacement, actions: [Action]) {
        self.placement = .after(after)
        self.actions = actions
    }
    
    init(replacing: CommandGroupPlacement, actions: [Action]) {
        self.placement = .replacing(replacing)
        self.actions = actions
    }
        
    var buttons: some View {
        ForEach(actions) { action in
            Button {
                openURL(action.url)
            } label: {
                Text(action.title)
            }
        }
    }
    
    var body: some Commands {
        switch placement {
        case .after(let after):
            CommandGroup(after: after) {
                buttons
            }
        case .replacing(let replacing):
            CommandGroup(replacing: replacing) {
                buttons
            }
        }
    }
    
}
