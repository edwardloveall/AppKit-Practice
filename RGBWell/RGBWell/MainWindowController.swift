//
//  MainWindowController.swift
//  RGBWell
//
//  Created by Edward Loveall on 2/3/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    @IBOutlet weak var colorWell: NSColorWell!

    override var windowNibName: String? {
        return "MainWindowController"
    }

    @IBAction func adjustRed(sender: NSSlider) {
        print("R slider's value is \(sender.floatValue)")
    }

    @IBAction func adjustGreen(sender: NSSlider) {
        print("G slider's value is \(sender.floatValue)")
    }

    @IBAction func adjustBlue(sender: NSSlider) {
        print("B slider's value is \(sender.floatValue)")
    }
}
