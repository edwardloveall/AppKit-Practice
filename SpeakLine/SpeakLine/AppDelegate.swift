//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by Edward Loveall on 11/26/15.
//  Copyright © 2015 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSSpeechSynthesizerDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var sourceText: NSTextField!
    var speechSynth: NSSpeechSynthesizer?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        speechSynth = NSSpeechSynthesizer.init(voice: nil)
        speechSynth?.delegate = self
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func sayIt(sender: AnyObject) {
        let string = sourceText.stringValue
        speechSynth?.startSpeakingString(string)
        stopButton.enabled = true
        speakButton.enabled = false
    }

    @IBAction func stopIt(sender: AnyObject) {
        speechSynth?.stopSpeaking()
    }

    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        stopButton.enabled = false
        speakButton.enabled = true
    }
}
