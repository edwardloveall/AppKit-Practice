//
//  MainWindowController.swift
//  ViewControl
//
//  Created by Edward Loveall on 8/17/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  let tabViewController: NerdTabViewController

  init(tabViewController: NerdTabViewController) {
    self.tabViewController = tabViewController
    super.init(window: NSWindow())
    window?.contentViewController = tabViewController
    window?.makeKeyAndOrderFront(self)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func windowDidLoad() {
    super.windowDidLoad()
  }
}
