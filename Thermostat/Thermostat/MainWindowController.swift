//
//  MainWindowController.swift
//  Thermostat
//
//  Created by Edward Loveall on 2/23/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    dynamic var temperature = 68

    override var windowNibName: String {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @IBAction func makeWarmer(sender: NSButton) {
        temperature += 1
    }

    @IBAction func makeCooler(sender: NSButton) {
        temperature -= 1
    }
}
