//
//  AppDelegate.swift
//  RanchForecast
//
//  Created by Edward Loveall on 8/3/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var mainWindowController: MainWindowController?

  func applicationDidFinishLaunching(notification: NSNotification) {
    let mainWindowController = MainWindowController()
    mainWindowController.showWindow(self)
    self.mainWindowController = mainWindowController
  }
}
