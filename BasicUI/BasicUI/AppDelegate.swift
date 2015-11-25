//
//  AppDelegate.swift
//  BasicUI
//
//  Created by Edward Loveall on 11/25/15.
//  Copyright © 2015 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var timeButton: NSButton!

    func applicationDidFinishLaunching(aNotification: NSNotification) {

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func time(sender: AnyObject) {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle

        timeLabel.stringValue = formatter.stringFromDate(now)
    }
}

