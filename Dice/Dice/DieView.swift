import Cocoa

@IBDesignable class DieView: NSView, NSDraggingSource {
    @IBInspectable dynamic var dotCount: Int = 1 {
        didSet {
            needsDisplay = true
        }
    }

    var pressed: Bool = false {
        didSet {
            needsDisplay = true
        }
    }

    var highlightForDragging: Bool = false {
        didSet {
            needsDisplay = true
        }
    }

    override var intrinsicContentSize: NSSize {
        return CGSize(width: 20, height: 20)
    }

    override var acceptsFirstResponder: Bool { return true }
    override var focusRingMaskBounds: NSRect { return bounds }

    var mouseDownEvent: NSEvent?
    var diePath = NSBezierPath()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        self.registerForDraggedTypes([NSPasteboardTypeString])
    }

    override func drawRect(dirtyRect: NSRect) {
        let backgroundColor = NSColor(red: 0.62,
                                      green: 0.62,
                                      blue: 0.62,
                                      alpha: 1.0)
        backgroundColor.set()
        NSBezierPath.fillRect(bounds)

        if highlightForDragging {
            if let gradient = NSGradient(startingColor: NSColor.whiteColor(),
                                         endingColor: backgroundColor) {
                gradient.drawInRect(bounds, relativeCenterPosition: NSZeroPoint)
            }
        } else {
            drawDieWithSize(bounds.size)
        }
    }

    func metricsForSize(size: CGSize) -> (edgeLength: CGFloat, dieFrame: CGRect) {
        let edgeLength = min(size.width, size.height)
        let padding = edgeLength / 10.0
        let drawingBounds = CGRect(x: 0,
                                   y: 0,
                                   width: edgeLength,
                                   height: edgeLength)
        var dieFrame = drawingBounds.insetBy(dx: padding, dy: padding)
        if pressed {
            dieFrame = dieFrame.offsetBy(dx: 0, dy: -edgeLength / 40)
        }

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
        if pressed {
            shadow.shadowBlurRadius = edgeLength / 100
        } else {
            shadow.shadowBlurRadius = edgeLength / 20
        }
        shadow.set()

        diePath = NSBezierPath(roundedRect: dieFrame,
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
        } else {
            let paraStyle = NSParagraphStyle
                .defaultParagraphStyle()
                .mutableCopy() as! NSMutableParagraphStyle
            paraStyle.alignment = .Center
            let font = NSFont.systemFontOfSize(edgeLength * 0.5)
            let attrs = [
                NSForegroundColorAttributeName: NSColor.blackColor(),
                NSFontAttributeName: font,
                NSParagraphStyleAttributeName: paraStyle
            ]
            let string = "\(dotCount)" as NSString
            string.drawCenteredInRect(dieFrame, attributes: attrs)
        }
    }

    func randomize() {
        dotCount = Int(arc4random_uniform(5)) + 1
    }

    override func mouseDown(theEvent: NSEvent) {
        mouseDownEvent = theEvent
        let pointInView = convertPoint(theEvent.locationInWindow, fromView: nil)
        pressed = diePath.containsPoint(pointInView)
    }

    override func mouseUp(theEvent: NSEvent) {
        if pressed && theEvent.clickCount == 2 {
            randomize()
        }
        pressed = false
    }

    override func mouseDragged(theEvent: NSEvent) {
        let downPoint = mouseDownEvent!.locationInWindow
        let dragPoint = theEvent.locationInWindow
        let distanceDragged = hypot(downPoint.x - dragPoint.x,
                                    downPoint.y - dragPoint.y)
        if distanceDragged < 3 {
            return
        }

        pressed = false

        let imageSize = bounds.size
        let image = NSImage(size: imageSize, flipped: false) { (imageBounds) in
            self.drawDieWithSize(imageBounds.size)
            return true
        }

        let draggingFrameOrigin = convertPoint(downPoint, fromView: nil)
        let dragTopLeft = NSRect(origin: draggingFrameOrigin, size: imageSize)
        let draggingFrame = dragTopLeft.offsetBy(dx: -imageSize.width / 2,
                                                 dy: -imageSize.height / 2)
        let item = NSDraggingItem(pasteboardWriter: "\(dotCount)")
        item.draggingFrame = draggingFrame
        item.imageComponentsProvider = {
            let component = NSDraggingImageComponent(key: NSDraggingImageComponentIconKey)
            component.contents = image
            component.frame = NSRect(origin: NSPoint(), size: imageSize)
            return [component]
        }

        beginDraggingSessionWithItems([item],
                                      event: mouseDownEvent!,
                                      source: self)
    }

    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func resignFirstResponder() -> Bool {
        return true
    }

    override func keyDown(theEvent: NSEvent) {
        interpretKeyEvents([theEvent])
    }

    override func insertText(insertString: AnyObject) {
        guard let numberString = insertString as? String,
              let number = Int(numberString) else {
            Swift.print("could not convert input \"\(insertString)\" into number")
            return
        }
        dotCount = number
    }

    override func insertTab(sender: AnyObject?) {
        window?.selectNextKeyView(sender)
    }

    override func insertBacktab(sender: AnyObject?) {
        window?.selectPreviousKeyView(sender)
    }

    override func drawFocusRingMask() {
        NSBezierPath.fillRect(bounds)
    }

    // MARK: - Drag Source

    func draggingSession(session: NSDraggingSession,
                         sourceOperationMaskForDraggingContext context: NSDraggingContext) -> NSDragOperation {
        return .Copy
    }

    // MARK: - Drag Destination

    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if sender.draggingSource() === self {
            return .None
        }
        highlightForDragging = true
        return sender.draggingSourceOperationMask()
    }

    override func draggingExited(sender: NSDraggingInfo?) {
        highlightForDragging = false
    }

    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        return true
    }

    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        guard let value = Pasteboard.readFromPasteboard(sender.draggingPasteboard()),
        let intValue = Int(value) else {
            return false
        }
        dotCount = intValue
        return true
    }

    override func concludeDragOperation(sender: NSDraggingInfo?) {
        highlightForDragging = false
    }

    // MARK: - Actions

    @IBAction func savePDF(sender: AnyObject!) {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["pdf"]
        savePanel.beginSheetModalForWindow(window!) {
            [unowned savePanel] (result) in
            if result == NSModalResponseOK {
                let data = PDFCreator(view: self).data(inside: self.bounds)
                do {
                    try data.writeToURL(savePanel.URL!,
                                        options: NSDataWritingOptions.DataWritingAtomic)
                } catch let error as NSError {
                    let alert = NSAlert(error: error)
                    alert.runModal()
                } catch {
                    fatalError("unknown error")
                }
            }
        }
    }

    @IBAction func cut(sender: AnyObject?) {
        let data = PDFCreator(view: self).data(inside: self.bounds)
        Pasteboard.writeToPasteboard((int: dotCount, data: data))
    }

    @IBAction func copy(sender: AnyObject?) {
        let data = PDFCreator(view: self).data(inside: self.bounds)
        Pasteboard.writeToPasteboard((int: dotCount, data: data))
    }

    @IBAction func paste(sender: AnyObject?) {
        if let value = Pasteboard.readFromPasteboard(nil) {
            guard let intValue = Int(value) else {
                return
            }
            dotCount = intValue
        }
    }
}
