//
//  AppDelegate.swift
//  ViewControl
//
//  Created by Edward Loveall on 8/16/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var window: NSWindow?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let flowViewController = ImageViewController()
    flowViewController.title = "Flow"
    flowViewController.image = NSImage(named: NSImageNameFlowViewTemplate)

    let columnViewController = ImageViewController()
    columnViewController.title = "Column"
    columnViewController.image = NSImage(named: NSImageNameColumnViewTemplate)

    let speakLine = SpeakLineViewController()
    speakLine.title = "Speach"

    let tabViewController = NerdTabViewController()
    tabViewController.addChildViewController(flowViewController)
    tabViewController.addChildViewController(columnViewController)
    tabViewController.addChildViewController(speakLine)

    let mainWindowController = MainWindowController(tabViewController: tabViewController)
    self.window = mainWindowController.window
  }
}
