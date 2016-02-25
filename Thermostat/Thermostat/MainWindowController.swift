//
//  MainWindowController.swift
//  Thermostat
//
//  Created by Edward Loveall on 2/23/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    dynamic var isOn = true
    private var privateTemperature = 68
    dynamic var temperature: Int {
        set {
            print("set temperature to \(newValue)")
            privateTemperature = newValue
        }
        get {
            print("get temperature")
            return privateTemperature
        }
    }

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
