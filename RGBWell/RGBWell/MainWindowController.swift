//
//  MainWindowController.swift
//  RGBWell
//
//  Created by Edward Loveall on 2/3/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    var r = 0.0
    var g = 0.0
    var b = 0.0
    let a = 1.0

    @IBOutlet weak var rSlider: NSSlider?
    @IBOutlet weak var gSlider: NSSlider!
    @IBOutlet weak var bSlider: NSSlider!

    @IBOutlet weak var colorWell: NSColorWell!

    override var windowNibName: String? {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        rSlider?.doubleValue = r
        gSlider.doubleValue = b
        bSlider.doubleValue = g
        updateColor()
    }

    @IBAction func adjustRed(sender: NSSlider) {
        r = sender.doubleValue
        updateColor()
    }

    @IBAction func adjustGreen(sender: NSSlider) {
        g = sender.doubleValue
        updateColor()
    }

    @IBAction func adjustBlue(sender: NSSlider) {
        b = sender.doubleValue
        updateColor()
    }

    func updateColor() {
        let newColor = NSColor(calibratedRed: CGFloat(r),
                                       green: CGFloat(g),
                                        blue: CGFloat(b),
                                       alpha: CGFloat(a))
        colorWell.color = newColor
    }
}
