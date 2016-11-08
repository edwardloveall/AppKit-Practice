//
//  AppDelegate.swift
//  Project1
//
//  Created by Edward Loveall on 11/1/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {}
  func applicationWillTerminate(_ aNotification: Notification) {}
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
