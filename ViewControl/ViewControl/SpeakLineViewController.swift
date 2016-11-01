//
//  SpeakLineViewController.swift
//  ViewControl
//
//  Created by Edward Loveall on 8/16/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class SpeakLineViewController: NSViewController,
                               NSSpeechSynthesizerDelegate,
                               NSWindowDelegate,
                               NSTableViewDataSource,
                               NSTableViewDelegate {
  @IBOutlet weak var textField: NSTextField!
  @IBOutlet weak var speakButton: NSButton!
  @IBOutlet weak var stopButton: NSButton!
  @IBOutlet weak var voicesTable: NSTableView!

  let speechSynth = NSSpeechSynthesizer()
  let voices = NSSpeechSynthesizer.availableVoices()
  var isStarted: Bool = false {
    didSet {
      updateButtons()
      disableTextField()
    }
  }

  override var nibName: String? {
    return "SpeakLineViewController"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    updateButtons()
    speechSynth.delegate = self
    setInterface()
  }

  func setInterface() {
    let defaultVoice = NSSpeechSynthesizer.defaultVoice()
    if let defaultRow = voices.index(of: defaultVoice) {
      let indices = IndexSet(integer: defaultRow)
      voicesTable.selectRowIndexes(indices, byExtendingSelection: false)
      voicesTable.scrollRowToVisible(defaultRow)
    }
  }

  // MARK: - Action Methods

  @IBAction func speakIt(_ sender: NSButton) {
    let string = textField.stringValue
    if string.isEmpty {
      print("string from \(textField) is empty")
    } else {
      speechSynth.startSpeaking(string)
      isStarted = true
    }
  }

  @IBAction func stopIt(_ sender: NSButton) {
    speechSynth.stopSpeaking()
  }

  func updateButtons() {
    if isStarted {
      speakButton.isEnabled = false
      stopButton.isEnabled = true
    } else {
      speakButton.isEnabled = true
      stopButton.isEnabled = false
    }
  }

  func disableTextField() {
    if isStarted {
      textField.isEnabled = false
    } else {
      textField.isEnabled = true
    }
  }

  func voiceNameForIdentifier(_ identifier: String) -> String? {
    let attributes = NSSpeechSynthesizer.attributes(forVoice: identifier)
    return attributes[NSVoiceName] as? String
  }

  @IBAction func reset(_ sender: NSButton) {
    setInterface()
  }

  // MARK: - NSSpeechSynthesizerDelegate

  func speechSynthesizer(_ sender: NSSpeechSynthesizer,
                         didFinishSpeaking finishedSpeaking: Bool) {
    isStarted = false
    textField.stringValue = textField.stringValue
  }

  func speechSynthesizer(_ sender: NSSpeechSynthesizer,
                         willSpeakWord characterRange: NSRange,
                                       of string: String) {
    let attributedString = NSMutableAttributedString(string: string)
    attributedString.addAttribute(NSForegroundColorAttributeName,
                                  value: NSColor.purple,
                                  range: characterRange)
    textField.attributedStringValue = attributedString
  }

  // MARK: - NSWindowDelegate

  func windowShouldClose(_ sender: Any) -> Bool {
    return !isStarted
  }

  // MARK: - NSTableViewDataSource

  func numberOfRows(in tableView: NSTableView) -> Int {
    return voices.count
  }

  func tableView(_ tableView: NSTableView,
                 objectValueFor tableColumn: NSTableColumn?,
                                           row: Int) -> Any? {
    let voice = voices[row]
    let voiceName = voiceNameForIdentifier(voice)
    return voiceName
  }

  // MARK: - NSTableViewDelegate

  func tableViewSelectionDidChange(_ notification: Notification) {
    let row = voicesTable.selectedRow
    if row == -1 {
      speechSynth.setVoice(nil)
      return
    }

    let voice = voices[row]
    speechSynth.setVoice(voice)
  }
}
