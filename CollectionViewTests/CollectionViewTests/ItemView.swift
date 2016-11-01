import Cocoa

class ItemView: NSView {
  let buttonSize = NSSize(width: 100, height: 20)
  let itemSize = NSSize(width: 120, height: 40)
  let buttonOrigin = NSPoint(x: 10, y: 10)

  var button: NSButton?

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }

  override init(frame frameRect: NSRect) {
    super.init(frame: NSRect(origin: frameRect.origin, size: itemSize))
    let newButton = NSButton(frame: NSRect(origin: buttonOrigin, size: buttonSize))
    newButton.bezelStyle = .rounded
    addSubview(newButton)
    button = newButton
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setButtonTitle(_ title: String) {
    button!.title = title
  }
}
