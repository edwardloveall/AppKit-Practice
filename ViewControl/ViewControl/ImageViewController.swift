import Cocoa

class ImageViewController: NSViewController, ImageRepresentable {
  var image: NSImage?
  let imageView = NSImageView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupConstraints()
  }

  override func loadView() {
    let initialFrame = NSRect(x: 0, y: 0, width: 480, height: 272)

    view = NSView(frame: initialFrame)
    imageView.image = image
    imageView.imageScaling = .ScaleProportionallyUpOrDown

    view.addSubview(imageView)
  }

  func setupConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 20).active = true
    imageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: -20).active = true
    imageView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 20).active = true
    imageView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -20).active = true
  }
}
