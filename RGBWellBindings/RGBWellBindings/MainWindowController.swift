//
//  MainWindowController.swift
//  RGBWellBindings
//
//  Created by Edward Loveall on 2/24/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    dynamic var r: Double = 0.0 {
        didSet { updateColors() }
    }
    dynamic var g: Double = 0.0 {
        didSet { updateColors() }
    }
    dynamic var b: Double = 0.0 {
        didSet { updateColors() }
    }
    dynamic var color = NSColor(calibratedRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    override var windowNibName: String {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    func updateColors() {
        color = NSColor(calibratedRed: CGFloat(r),
                                green: CGFloat(g),
                                 blue: CGFloat(b),
                                alpha: 1.0)
    }
}
