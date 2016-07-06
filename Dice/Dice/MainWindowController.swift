//
//  MainWindowController.swift
//  Dice
//
//  Created by Edward Loveall on 4/27/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  var configurationWindowController: ConfigurationWindowController?

  override var windowNibName: String? {
    return "MainWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()
  }

  @IBAction func showDieConfiguration(sender: AnyObject?) {
    guard let window = window,
          let dieView = window.firstResponder as? DieView else {
      print("could not retrieve DieView")
      return
    }

    let windowController = ConfigurationWindowController()
    windowController.configuration = DieConfiguration(color: dieView.color,
                                                      rolls: dieView.numberOfTimesToRoll)
    guard let configWindow = windowController.window else {
      print("could not retrieve configWindow")
      return
    }

    window.beginSheet(configWindow, completionHandler: { response in
      if response == NSModalResponseOK {
        let configuration = self.configurationWindowController!.configuration
        dieView.color = configuration.color
        dieView.numberOfTimesToRoll = configuration.rolls
      }
      self.configurationWindowController = nil
    })
    configurationWindowController = windowController
  }
}
