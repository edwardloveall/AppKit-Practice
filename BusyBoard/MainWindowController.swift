//
//  MainWindowController.swift
//  BusyBoard
//
//  Created by Edward Loveall on 2/5/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    var sliderValue: Double = 0

    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var showTicksRadio: NSButton!
    @IBOutlet weak var hideTicksRadio: NSButton!
    @IBOutlet weak var sliderLabel: NSTextField!
    @IBOutlet weak var checkBox: NSButton!
    @IBOutlet weak var secureText: NSTextField!
    @IBOutlet weak var normalText: NSTextField!

    override var windowNibName: String {
        return "MainWindowController"
    }

    @IBAction func toggleTickMarks(sender: NSButton) {
        if (sender.tag == 0) {
            slider.numberOfTickMarks = 0
        } else if (sender.tag == 1) {
            slider.numberOfTickMarks = 10
        }
    }

    @IBAction func moveSlider(sender: NSSlider) {
        if (sender.doubleValue == 0) {
            sliderLabel.stringValue = ""
        } else if (sender.doubleValue > sliderValue) {
            sliderLabel.stringValue = "Slider goes up!"
        } else if (sender.doubleValue < sliderValue) {
            sliderLabel.stringValue = "Slider goes down!"
        }
        sliderValue = sender.doubleValue
    }

    @IBAction func checkMe(sender: NSButton) {
        if (sender.state == 1) {
            sender.title = "Uncheck me!"
        } else if (sender.state == 0) {
            sender.title = "Check me!"
        }
    }

    @IBAction func revealMessage(sender: NSButton) {
        normalText.stringValue = secureText.stringValue
    }

    @IBAction func resetControls(sender: NSButton) {
        slider.doubleValue = 0
        slider.numberOfTickMarks = 0
        sliderLabel.stringValue = ""
        showTicksRadio.state = NSOffState
        hideTicksRadio.state = NSOnState
        checkBox.state = 0
        checkBox.title = "Check me!"
        secureText.stringValue = ""
        normalText.stringValue = ""
    }
}
