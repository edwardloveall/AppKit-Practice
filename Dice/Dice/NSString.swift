import Cocoa

extension NSString {
    func drawCenteredInRect(rect: NSRect, attributes: [String: AnyObject]?) {
        let stringSize = sizeWithAttributes(attributes)
        let x = rect.origin.x + (rect.width - stringSize.width) / 2.0
        let y = rect.origin.y + (rect.height - stringSize.height) / 2.0
        let point = NSPoint(x: x, y: y)

        drawAtPoint(point, withAttributes: attributes)
    }
}