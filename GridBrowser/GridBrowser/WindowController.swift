import Cocoa

class WindowController: NSWindowController {
  @IBOutlet var addressEntry: NSTextField!
  @IBOutlet var loadControlButton: NSButton!

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden
  }
}
