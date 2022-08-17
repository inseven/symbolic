import SwiftUI

struct Document {

    var topColor: Color = Color(NSColor(.black).lighter(by: 25))
    var bottomColor: Color = .black

    var systemImage: String = "face.smiling"
    var symbolColor: Color = .white

    var shadowOpacity: CGFloat = 0.5
    var shadowHeight: CGFloat = 0.2

}
