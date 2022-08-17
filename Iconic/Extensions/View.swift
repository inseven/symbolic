import SwiftUI

extension View {

    @MainActor func snapshot(scale: Int = 1) -> Data? {
        let renderer = ImageRenderer(content: self)
        guard let image = renderer.cgImage else {
            return nil
        }
        let imageRep = NSBitmapImageRep(cgImage: image)
        imageRep.size = CGSize(width: image.width, height: image.height)
        return imageRep.representation(using: .png, properties: [:])
    }

}
