//
//  ThingController.swift
//  BasicUI
//
//  Created by Edward Loveall on 11/25/15.
//  Copyright © 2015 Edward Loveall. All rights reserved.
//

import Cocoa

class ThingController: NSViewController {
    @IBOutlet weak var timeButton: NSButton!
    @IBOutlet weak var timeLabel: NSTextField!

    @IBAction func time(sender: AnyObject) {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle

        timeLabel.stringValue = formatter.stringFromDate(now)
    }
}