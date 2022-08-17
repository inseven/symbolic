import SwiftUI

struct IconCorners: ViewModifier {

    struct LayoutMetrics {
        static let cornerRadiusRatio = 0.1754
    }

    let size: CGFloat

    func body(content: Content) -> some View {
        content.self
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * LayoutMetrics.cornerRadiusRatio, style: .continuous))
    }

}
