//
//  MainWindowController.swift
//  RandomPassword
//
//  Created by Edward Loveall on 1/21/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    @IBOutlet weak var textField: NSTextField!
    override var windowNibName: String? {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        print("window loaded from NIB named \(windowNibName)")
    }

    @IBAction func generatePassword(sender: AnyObject) {
        let length = 8
        let password = generateRandomString(length)
        textField.stringValue = password
    }

    deinit {
        print("\(self) will be decallocated")
    }
}
