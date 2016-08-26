import Cocoa

@objc
protocol ImageRepresentable {
  var image: NSImage? { get }
}

class NerdTabViewController: NSViewController {
  var container = NSView()
  var buttons = [NSButton]()

  func selectTabAtIndex(index: Int) {
    let range = 0..<childViewControllers.count
    assert(range.contains(index), "index out of range")

    for (i, button) in buttons.enumerate() {
      if index == i {
        button.state = NSOnState
      } else {
        button.state = NSOffState
      }
    }
    let imageView = childViewControllers[index].view
    container.subviews = []
    container.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.topAnchor.constraintEqualToAnchor(container.topAnchor).active = true
    imageView.bottomAnchor.constraintEqualToAnchor(container.bottomAnchor).active = true
    imageView.leadingAnchor.constraintEqualToAnchor(container.leadingAnchor).active = true
    imageView.trailingAnchor.constraintEqualToAnchor(container.trailingAnchor).active = true
  }

  func selectTab(sender: NSButton) {
    let index = sender.tag
    selectTabAtIndex(index)
  }

  override func loadView() {
    view = NSView()
    reset()
  }

  func reset() {
    view.subviews = []
    let buttonWidth: CGFloat = 28
    let buttonHeight: CGFloat = 28

    buttons = childViewControllers.enumerate().map {
      (index, viewController) -> NSButton in
      let button = NSButton()
      button.setButtonType(.ToggleButton)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.bordered = false
      button.target = self
      button.action = #selector(NerdTabViewController.selectTab(_:))
      button.tag = index
      if let viewController = viewController as? ImageRepresentable {
        button.image = viewController.image
      } else {
        button.title = viewController.title ?? "View Controller"
      }
      button.widthAnchor.constraintGreaterThanOrEqualToConstant(buttonWidth).active = true
      button.heightAnchor.constraintEqualToConstant(buttonHeight).active = true
      return button
    }

    let stackView = NSStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.orientation = .Horizontal
    stackView.spacing = 4
    for button in buttons {
      stackView.addView(button, inGravity: .Center)
    }

    container.translatesAutoresizingMaskIntoConstraints = false

    let separator = NSBox()
    separator.boxType = .Separator
    separator.translatesAutoresizingMaskIntoConstraints = false

    view.subviews = [stackView, separator, container]

    stackView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
    stackView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    stackView.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
    stackView.bottomAnchor.constraintEqualToAnchor(separator.topAnchor).active = true
    stackView.heightAnchor.constraintEqualToConstant(buttonHeight).active = true
    separator.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
    separator.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    separator.bottomAnchor.constraintEqualToAnchor(container.topAnchor).active = true
    separator.heightAnchor.constraintEqualToConstant(1).active = true
    container.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
    container.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    container.widthAnchor.constraintGreaterThanOrEqualToConstant(100).active = true
    container.heightAnchor.constraintGreaterThanOrEqualToConstant(100).active = true
    container.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true

    if childViewControllers.count > 0 {
      selectTabAtIndex(0)
    }
  }

  override func insertChildViewController(childViewController: NSViewController,
                                          atIndex index: Int) {
    super.insertChildViewController(childViewController, atIndex: index)
    if viewLoaded {
      reset()
    }
  }

  override func removeChildViewControllerAtIndex(index: Int) {
    super.removeChildViewControllerAtIndex(index)
    if viewLoaded {
      reset()
    }
  }
}
