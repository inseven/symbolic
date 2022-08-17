import AppKit

extension NSColor {

    func lighter(by percentage: CGFloat = 30.0) -> NSColor {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> NSColor {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> NSColor {
        return NSColor(red: min(redComponent + percentage/100, 1.0),
                       green: min(greenComponent + percentage/100, 1.0),
                       blue: min(blueComponent + percentage/100, 1.0),
                       alpha: alphaComponent)
    }
}
