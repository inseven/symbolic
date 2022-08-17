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
