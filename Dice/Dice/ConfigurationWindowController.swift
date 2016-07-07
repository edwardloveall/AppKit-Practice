//
//  ConfigurationWindowController.swift
//  Dice
//
//  Created by Edward Loveall on 7/6/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

struct DieConfiguration {
  let color: NSColor
  let rolls: Int

  init(color: NSColor, rolls: Int) {
    self.color = color
    self.rolls = max(rolls, 1)
  }
}

class ConfigurationWindowController: NSWindowController {
  var configuration: DieConfiguration {
    set {
      color = newValue.color
      rolls = newValue.rolls
    }

    get {
      return DieConfiguration(color: color, rolls: rolls)
    }
  }

  private dynamic var color: NSColor = NSColor.whiteColor()
  private dynamic var rolls: Int = 10

  override var windowNibName: String? {
    return "ConfigurationWindowController"
  }

  @IBAction func okayButtonClicked(button: NSButton) {
    window?.endEditingFor(nil)
    dismissWithModalResponse(NSModalResponseOK)
  }

  @IBAction func cancelButtonClicked(button: NSButton) {
    dismissWithModalResponse(NSModalResponseCancel)
  }

  func dismissWithModalResponse(response: NSModalResponse) {
    window?.sheetParent?.endSheet(window!, returnCode: response)
  }

  func presentAsSheetOnWindow(window: NSWindow,
                              completionHandler: (config: DieConfiguration?) -> ()) {
    guard let myWindow = self.window else { fatalError("can't find window") }
    window.beginSheet(myWindow, completionHandler: { response in
      switch response {
        case NSModalResponseOK: completionHandler(config: self.configuration)
        case NSModalResponseCancel: completionHandler(config: nil)
        default: completionHandler(config: nil)
      }
    })
  }
}
