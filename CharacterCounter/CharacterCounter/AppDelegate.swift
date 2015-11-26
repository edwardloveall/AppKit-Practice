//
//  AppDelegate.swift
//  CharacterCounter
//
//  Created by Edward Loveall on 11/26/15.
//  Copyright © 2015 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textSource: NSTextField!
    @IBOutlet weak var countButton: NSButton!
    @IBOutlet weak var characterDisplay: NSTextField!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func countCharacters(sender: AnyObject) {
        let characterCount = textSource.stringValue.characters.count
        characterDisplay.stringValue = "\(characterCount) characters"
    }
}

