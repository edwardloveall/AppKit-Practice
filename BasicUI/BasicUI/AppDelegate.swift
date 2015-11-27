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
    @IBOutlet weak var mainWindow: NSWindow!

    // putting outlet and label in AppDel to see if button is active as expected
    @IBOutlet weak var appDelLabel: NSTextField!
    @IBAction func appDelButton(sender: AnyObject) {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        
        appDelLabel.stringValue = formatter.stringFromDate(now) + " from App Delegate"
    }
    func applicationDidFinishLaunching(aNotification: NSNotification) {

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

