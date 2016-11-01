import Cocoa

@objc
protocol ImageRepresentable {
  var image: NSImage? { get }
}

class NerdTabViewController: NSViewController {
  var container = NSView()
  var buttons = [NSButton]()

  func selectTabAtIndex(_ index: Int) {
    let range = 0..<childViewControllers.count
    assert(range.contains(index), "index out of range")

    for (i, button) in buttons.enumerated() {
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
    imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
  }

  func selectTab(_ sender: NSButton) {
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

    buttons = childViewControllers.enumerated().map {
      (index, viewController) -> NSButton in
      let button = NSButton()
      button.setButtonType(.toggle)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.isBordered = false
      button.target = self
      button.action = #selector(NerdTabViewController.selectTab(_:))
      button.tag = index
      if let viewController = viewController as? ImageRepresentable {
        button.image = viewController.image
      } else {
        button.title = viewController.title ?? "View Controller"
      }
      button.widthAnchor.constraint(greaterThanOrEqualToConstant: buttonWidth).isActive = true
      button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
      return button
    }

    let stackView = NSStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.orientation = .horizontal
    stackView.spacing = 4
    for button in buttons {
      stackView.addView(button, in: .center)
    }

    container.translatesAutoresizingMaskIntoConstraints = false

    let separator = NSBox()
    separator.boxType = .separator
    separator.translatesAutoresizingMaskIntoConstraints = false

    view.subviews = [stackView, separator, container]

    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
    stackView.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
    separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    separator.bottomAnchor.constraint(equalTo: container.topAnchor).isActive = true
    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    container.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    container.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    container.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    if childViewControllers.count > 0 {
      selectTabAtIndex(0)
    }
  }

  override func insertChildViewController(_ childViewController: NSViewController,
                                          at index: Int) {
    super.insertChildViewController(childViewController, at: index)
    if isViewLoaded {
      reset()
    }
  }

  override func removeChildViewController(at index: Int) {
    super.removeChildViewController(at: index)
    if isViewLoaded {
      reset()
    }
  }
}
