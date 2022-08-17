import SwiftUI

struct Icon: View {

    struct Constants {
        static let shadowOffsetScaleFactor = 0.125
    }

    var iconScale: CGFloat
    var document: Document
    var size: CGFloat

    var body: some View {
        ZStack {
            let iconSize = size * iconScale
            let x = size / 2
            let y = size / 2
            let shadowRadius = size * document.shadowHeight * Constants.shadowOffsetScaleFactor
            let shadowOffset = size * document.shadowHeight * Constants.shadowOffsetScaleFactor * 1.25

            LinearGradient(gradient: Gradient(colors: [document.topColor, document.bottomColor]),
                           startPoint: .top,
                           endPoint: .bottom)
            VStack {
                Image(systemName: document.systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(document.symbolColor)
                    .shadow(color: .black.opacity(document.shadowOpacity),
                            radius: shadowRadius,
                            x: 0,
                            y: shadowOffset)
            }
            .frame(width: iconSize, height: iconSize)
            .position(x: x, y: y)
        }
        .frame(width: size, height: size)
    }

}
