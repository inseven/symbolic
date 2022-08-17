import SwiftUI

struct SymbolPicker: View {

    var title: String
    var systemImage: Binding<String>
    @State var initialImage: String
    @State var isPresented: Bool = false
    @StateObject var model = SymbolPickerModel()

    init(_ title: String, systemImage: Binding<String>) {
        self.title = title
        self.systemImage = systemImage
        _initialImage = State(initialValue: systemImage.wrappedValue)
    }

    let columns = [GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0),
                   GridItem(.flexible(minimum: 38), spacing: 16.0)]

    var body: some View {
        LabeledContent("Symbol") {
            Button {
                isPresented = true
            } label: {
                HStack {
                    Image(systemName: systemImage.wrappedValue)
                        .resizable()
                }
                .frame(width: 12, height: 12)
            }
            .popover(isPresented: $isPresented) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16.0) {
                        ForEach(model.filteredSymbolNames) { symbol in
                            HStack {
                                Image(systemName: symbol)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .controlSize(.regular)
                                    .onHover { inside in
                                        if inside {
                                            systemImage.wrappedValue = symbol
                                        } else {
                                            systemImage.wrappedValue = initialImage
                                        }
                                    }
                                    .onTapGesture {
                                        isPresented = false
                                        systemImage.wrappedValue = symbol
                                    }
                            }
                            .aspectRatio(1.0, contentMode: .fit)
                        }
                    }
                    .padding()
                }
                .safeAreaInset(edge: .top) {
                    TextField(text: $model.filter, prompt: Text("Search")) {
                        EmptyView()
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .background(.regularMaterial)
                }
                .frame(height: 400)
            }
        }
        .onAppear {
            model.start()
        }
        .onDisappear {
            model.stop()
        }

    }

}
