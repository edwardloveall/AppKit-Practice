import Cocoa

class PDFCreator {
    let view: NSView

    init(view: NSView) {
        self.view = view
    }

    func data(inside rect: NSRect) -> NSData {
        return view.dataWithPDFInsideRect(rect)
    }
}