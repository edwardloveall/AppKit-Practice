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

    let tabViewController = NSTabViewController()
    tabViewController.addChildViewController(flowViewController)
    tabViewController.addChildViewController(columnViewController)
    tabViewController.addChildViewController(speakLine)

    let window = NSWindow(contentViewController: tabViewController)
    window.contentView = tabViewController.view
    window.makeKeyAndOrderFront(self)
    self.window = window
  }
}
