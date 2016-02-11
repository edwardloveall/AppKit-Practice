//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Edward Loveall on 2/11/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!

    let speechSynth = NSSpeechSynthesizer()
    var isStarted: Bool = false {
        didSet {
            updateButtons()
        }
    }

    override var windowNibName: String {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        updateButtons()
        speechSynth.delegate = self
    }

    // MARK: - Action Methods

    @IBAction func speakIt(sender: NSButton) {
        let string = textField.stringValue
        if string.isEmpty {
            print("string from \(textField) is empty")
        } else {
            speechSynth.startSpeakingString(string)
            isStarted = true
        }
    }

    @IBAction func stopIt(sender: NSButton) {
        speechSynth.stopSpeaking()
    }

    func updateButtons() {
        if isStarted {
            speakButton.enabled = false
            stopButton.enabled = true
        } else {
            speakButton.enabled = true
            stopButton.enabled = false
        }
    }

    // MARK: - NSSpeechSynthesizerDelegate

    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
        print("finishedSpeaking=\(finishedSpeaking)")
    }

    // MARK: - NSWindowDelegate

    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
}
