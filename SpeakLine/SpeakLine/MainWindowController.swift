//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Edward Loveall on 2/11/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var voicesTable: NSTableView!

    let speechSynth = NSSpeechSynthesizer()
    let voices = NSSpeechSynthesizer.availableVoices()
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
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        if let defaultRow = voices.indexOf(defaultVoice) {
            let indices = NSIndexSet(index: defaultRow)
            voicesTable.selectRowIndexes(indices, byExtendingSelection: false)
            voicesTable.scrollRowToVisible(defaultRow)
        }
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

    func voiceNameForIdentifier(identifier: String) -> String? {
        let attributes = NSSpeechSynthesizer.attributesForVoice(identifier)
        return attributes[NSVoiceName] as? String
    }

    // MARK: - NSSpeechSynthesizerDelegate

    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
    }

    // MARK: - NSWindowDelegate

    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }

    // MARK: - NSTableViewDataSource

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(voice)
        return voiceName
    }

    // MARK: - NSTableViewDelegate

    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = voicesTable.selectedRow
        if row == -1 {
            speechSynth.setVoice(nil)
            return
        }

        let voice = voices[row]
        speechSynth.setVoice(voice)
    }
}
