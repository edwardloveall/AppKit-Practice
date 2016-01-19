//
//  AppDelegate.swift
//  widthDoubleHeight
//
//  Created by Edward Loveall on 1/19/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func windowWillResize(sender: NSWindow, toSize frameSize: NSSize) -> NSSize {
        let doubleWidth = frameSize.width * 2
        return NSMakeSize(frameSize.width, doubleWidth)
    }
}

