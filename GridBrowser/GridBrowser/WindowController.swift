import Cocoa

class WindowController: NSWindowController {
  @IBOutlet var addressEntry: NSTextField!

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden
  }
}
