import Cocoa
import WebKit

class ViewController: NSViewController,
                      WKNavigationDelegate,
                      NSGestureRecognizerDelegate {
  var rows: NSStackView!
  var selectedWebView: WKWebView!

  override func viewDidLoad() {
    super.viewDidLoad()

    rows = NSStackView()
    rows.orientation = .vertical
    rows.distribution = .fillEqually
    rows.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(rows)

    rows.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    rows.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    rows.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    rows.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    let column = NSStackView(views: [makeWebView()])
    column.distribution = .fillEqually

    rows.addArrangedSubview(column)
  }

  override var representedObject: Any? {
    didSet {}
  }

  @IBAction func urlEntered(_ sender: NSTextField) {
    guard
      let selected = selectedWebView
    else { return }

    if let url = URL(string: sender.stringValue) {
      selected.load(URLRequest(url: url))
    }
  }

  @IBAction func navigationClicked(_ sender: NSSegmentedControl) {
    guard let selected = selectedWebView else { return }

    if sender.selectedSegment == 0 {
      selected.goBack()
    } else {
      selected.goForward()
    }
  }

  @IBAction func loadControlClicked(_ sender: NSButton) {
    guard let selected = selectedWebView else { return }

    if selected.isLoading {
      selected.stopLoading()
    } else {
      selected.reload()
    }
  }

  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    guard
      let windowController = view.window?.windowController as? WindowController,
      let button = windowController.loadControlButton
      else { return }

    button.image = NSImage(named: NSImageNameStopProgressTemplate)
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    guard
      let windowController = view.window?.windowController as? WindowController,
      let button = windowController.loadControlButton
      else { return }

    button.image = NSImage(named: NSImageNameRefreshTemplate)
  }

  @IBAction func adjustRows(_ sender: NSSegmentedControl) {
    if sender.selectedSegment == 0 {
      let columnCount = (rows.arrangedSubviews[0] as! NSStackView).arrangedSubviews.count
      let viewArray = [NSView](repeating: makeWebView(), count: columnCount)

      let row = NSStackView(views: viewArray)
      row.distribution = .fillEqually
      rows.addArrangedSubview(row)
    } else {
      guard rows.arrangedSubviews.count > 1,
        let rowToRemove = rows.arrangedSubviews.last as? NSStackView
      else { return }

      for cell in rowToRemove.arrangedSubviews {
        cell.removeFromSuperview()
      }
      rows.removeArrangedSubview(rowToRemove)
    }
  }

  @IBAction func adjustColumns(_ sender: NSSegmentedControl) {
    if sender.selectedSegment == 0 {
      for case let row as NSStackView in rows.arrangedSubviews {
        row.addArrangedSubview(makeWebView())
      }
    } else {
      guard
        let firstRow = rows.arrangedSubviews.first as? NSStackView,
        firstRow.arrangedSubviews.count > 1
      else { return }

      for case let row as NSStackView in rows.arrangedSubviews {
        if let last = row.arrangedSubviews.last {
          row.removeArrangedSubview(last)
          last.removeFromSuperview()
        }
      }
    }
  }

  func makeWebView() -> NSView {
    let webView = WKWebView()
    webView.navigationDelegate = self
    webView.wantsLayer = true

    if let url = URL(string: "https://www.apple.com") {
      let request = URLRequest(url: url)
      webView.load(request)
    }

    let recognizer = NSClickGestureRecognizer(target: self,
                                              action: #selector(webViewClicked))
    recognizer.delegate = self
    webView.addGestureRecognizer(recognizer)

    if selectedWebView == nil {
      select(webView: webView)
    }

    return webView
  }

  func select(webView: WKWebView) {
    selectedWebView = webView
    selectedWebView.layer?.borderWidth = 4
    selectedWebView.layer?.borderColor = NSColor.blue.cgColor

    if let windowController = view.window?.windowController as? WindowController {
      windowController.addressEntry.stringValue = selectedWebView.url?.absoluteString ?? ""
    }
  }

  func webViewClicked(recognizer: NSClickGestureRecognizer) {
    guard let newSelectedWebView = recognizer.view as? WKWebView
    else { return }

    if let selected = selectedWebView {
      selected.layer?.borderWidth = 0
    }

    select(webView: newSelectedWebView)
  }

  func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer,
                         shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
    if gestureRecognizer.view == selectedWebView {
      return false
    } else {
      return true
    }
  }

  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    guard webView == selectedWebView else { return }

    if let windowController = view.window?.windowController as? WindowController {
      windowController.addressEntry.stringValue = webView.url?.absoluteString ?? ""
    }
  }
}
