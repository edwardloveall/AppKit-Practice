//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by Edward Loveall on 11/26/15.
//  Copyright © 2015 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var sourceText: NSTextField!
    @IBOutlet weak var voicesTable: NSTableView!
    var speechSynth: NSSpeechSynthesizer?
    var voices: [String] = []

    override init() {
        super.init()
        speechSynth = NSSpeechSynthesizer.init(voice: nil)
        speechSynth?.delegate = self
        voices = NSSpeechSynthesizer.availableVoices()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {}
    func applicationWillTerminate(aNotification: NSNotification) {}

    override func awakeFromNib() {
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        if let defaultRow = voices.indexOf(defaultVoice) {
            let indices = NSIndexSet(index: defaultRow)
            voicesTable.selectRowIndexes(indices, byExtendingSelection: false)
            voicesTable.scrollRowToVisible(defaultRow)
        }
    }

    @IBAction func sayIt(sender: AnyObject) {
        let string = sourceText.stringValue
        speechSynth?.startSpeakingString(string)
        stopButton.enabled = true
        speakButton.enabled = false
        voicesTable.enabled = false
    }

    @IBAction func stopIt(sender: AnyObject) {
        speechSynth?.stopSpeaking()
    }

    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        stopButton.enabled = false
        speakButton.enabled = true
        voicesTable.enabled = true
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voiceIdentifier = voices[row]
        let voiceDictionary = NSSpeechSynthesizer.attributesForVoice(voiceIdentifier)
        return voiceDictionary[NSVoiceName]
    }

    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = voicesTable.selectedRow
        if row == -1 {
            return
        }
        let selectedVoice = voices[row]
        speechSynth?.setVoice(selectedVoice)
        print("new voice = \(selectedVoice)")
    }

    override func respondsToSelector(aSelector: Selector) -> Bool {
        let methodName = NSStringFromSelector(aSelector)
        print("responds to \(methodName)")
        return super.respondsToSelector(aSelector)
    }
}
