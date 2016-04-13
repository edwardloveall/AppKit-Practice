//
//  AppDelegate.swift
//  Chatter
//
//  Created by Edward Loveall on 4/13/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowControllers: [ChatWindowController] = []

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        addWindowController()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func displayNewWindow(sender: NSMenuItem) {
        addWindowController()
    }

    func addWindowController() {
        let windowController = ChatWindowController()

        windowController.showWindow(self)
        windowControllers.append(windowController)
    }
}

