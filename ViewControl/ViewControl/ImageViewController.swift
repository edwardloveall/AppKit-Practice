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
    imageView.imageScaling = .scaleProportionallyUpOrDown

    view.addSubview(imageView)
  }

  func setupConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
    imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
  }
}
