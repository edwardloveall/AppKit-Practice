import Cocoa
import WebKit

class WebViewController: NSViewController {
  var webView: WKWebView {
    guard
      let view = view as? WKWebView
    else {
      fatalError("Couldn't get webview")
    }

    return view
  }

  override func loadView() {
    let webView = WKWebView()
    view = webView
  }

  func loadURL(url: NSURL) {
    let request = NSURLRequest(URL: url)
    webView.loadRequest(request)
  }
}