import Cocoa

class WindowController: NSWindowController {
  @IBOutlet var shareButton: NSButton!

  override func windowDidLoad() {
    super.windowDidLoad()
    shareButton.sendAction(on: .leftMouseDown)
  }

  @IBAction func shareClicked(_ sender: NSView) {
    guard
      let split = contentViewController as? ViewController,
      let detail = split.childViewControllers[1] as? DetailViewController,
      let image = detail.imageView.image
      else { return }

    let picker = NSSharingServicePicker(items: [image])
    picker.show(relativeTo: .zero, of: sender, preferredEdge: .minY)
  }
}
