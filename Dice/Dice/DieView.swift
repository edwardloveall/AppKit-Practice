import Cocoa

@IBDesignable class DieView: NSView {
    @IBInspectable dynamic var dotCount: Int = 1 {
        didSet {
            needsDisplay = true
        }
    }

    override var intrinsicContentSize: NSSize {
        return CGSize(width: 20, height: 20)
    }

    override func drawRect(dirtyRect: NSRect) {
        let backgroundColor = NSColor(red: 0.06,
                                      green: 0.62,
                                      blue: 0.12,
                                      alpha: 1.0)
        backgroundColor.set()
        NSBezierPath.fillRect(bounds)

        drawDieWithSize(bounds.size)
    }

    func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength / 10.0
        let drawingBounds = CGRect(x: 0,
                                   y: 0,
                                   width: edgeLength,
                                   height: edgeLength)
        let dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)
        return (edgeLength, dieFrame)
    }

    func drawDieWithSize(size: CGSize) {
        let (edgeLength, dieFrame) = metricsForSize(size)
        let cornerRadius = edgeLength / 5.0

        let dotRadius = edgeLength / 12.0
        let dotFrame = dieFrame.insetBy(dx: dotRadius * 2.5,
                                        dy: dotRadius * 2.5)

        NSGraphicsContext.saveGraphicsState()

        let shadow = NSShadow()
        shadow.shadowOffset = NSSize(width: 0, height: -1)
        shadow.shadowBlurRadius = edgeLength / 20
        shadow.set()

        let diePath = NSBezierPath(roundedRect: dieFrame,
                                   xRadius: cornerRadius,
                                   yRadius: cornerRadius)
        NSColor.whiteColor().set()
        diePath.fill()

        NSGraphicsContext.restoreGraphicsState()

        NSColor.blackColor().set()
        diePath.lineWidth = edgeLength / 80
        diePath.stroke()

        func drawDot(horizontalOffset: CGFloat, _ verticalOffset: CGFloat) {
            let x = dotFrame.minX + dotFrame.width * horizontalOffset
            let y = dotFrame.minY + dotFrame.height * verticalOffset
            let dotOrigin = CGPoint(x: x, y: y)
            let dotRect = CGRect(origin: dotOrigin, size: CGSizeZero)
                .insetBy(dx: -dotRadius, dy: -dotRadius)
            NSColor.blackColor().set()
            NSBezierPath(ovalInRect: dotRect).fill()

            NSColor(calibratedWhite: 1, alpha: 0.6).set()
            let glintRadius = dotRadius * 0.2
            let glintOrigin = CGPoint(x: dotOrigin.x + glintRadius,
                                      y: dotOrigin.y - glintRadius)
            let glintRect = CGRect(origin: glintOrigin, size: CGSizeZero)
                .insetBy(dx: -glintRadius, dy: -glintRadius)
            NSBezierPath(ovalInRect: glintRect).fill()
        }

        if (1...6).indexOf(dotCount) != nil {
            if dotCount % 2 == 1 {
                drawDot(0.5, 0.5)
            }

            if dotCount > 1 {
                drawDot(0, 1)
                drawDot(1, 0)
            }

            if dotCount > 3 {
                drawDot(1, 1)
                drawDot(0, 0)
            }

            if dotCount == 6 {
                drawDot(0, 0.5)
                drawDot(1, 0.5)
            }
        }
    }
}
