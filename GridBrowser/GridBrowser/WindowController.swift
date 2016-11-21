import Cocoa

class WindowController: NSWindowController {
  @IBOutlet var addressEntry: NSTextField!
  @IBOutlet var loadControlButton: NSButton!
  @IBOutlet var navigation: NSSegmentedControl!

  override func windowDidLoad() {
    super.windowDidLoad()
    window?.titleVisibility = .hidden
  }
}
