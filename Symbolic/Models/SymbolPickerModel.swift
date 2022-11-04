// Copyright (c) 2022 InSeven Limited
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

class SymbolPickerModel: ObservableObject {

    @Published var filteredSymbolNames: [String] = []
    @Published var filter: String = ""

    var cancellables: Set<AnyCancellable> = []

    @MainActor func start() {
        $filter
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .map { filter in
                if filter.isEmpty {
                    return SFSymbols.allNames
                }
                return SFSymbols.allNames.filter { $0.localizedCaseInsensitiveContains(filter) }
            }
            .receive(on: DispatchQueue.main)
            .sink { filteredSymbolNames in
                self.filteredSymbolNames = filteredSymbolNames
            }
            .store(in: &cancellables)
    }

    @MainActor func stop() {
        cancellables.removeAll()
    }

}
