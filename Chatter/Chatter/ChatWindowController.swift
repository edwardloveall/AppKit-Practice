//
//  ChatWindowController.swift
//  Chatter
//
//  Created by Edward Loveall on 4/13/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

private let ChatWindowControllerDidSendMessageNotification = "com.edwardloveall.Chatter.ChatWindowControllerDidSendMessageNotification"
private let ChatWindowControllerMessageKey = "com.edwardloveall.Chatter.ChatWindowControllerMessageKey"

class ChatWindowController: NSWindowController {
    dynamic var log: NSAttributedString = NSAttributedString(string: "")
    dynamic var message: String?

    override var windowNibName: String? {
        return "ChatWindowController"
    }

    @IBOutlet var textView: NSTextView!

    override func windowDidLoad() {
        super.windowDidLoad()

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
                                       selector: #selector(ChatWindowController.receiveDidSendMessageNotification(_:)),
                                       name: ChatWindowControllerDidSendMessageNotification,
                                       object: nil)
    }

    @IBAction func send(sender: NSButton) {
        sender.window?.endEditingFor(nil)
        guard let message = message else {
            return
        }
        let userInfo = [ChatWindowControllerMessageKey : message]
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(ChatWindowControllerDidSendMessageNotification,
                                                object: self,
                                                userInfo: userInfo)
        self.message = ""
    }

    func receiveDidSendMessageNotification(note: NSNotification) {
        let mutableLog = log.mutableCopy() as! NSMutableAttributedString
        if log.length > 0 {
            mutableLog.appendAttributedString(NSAttributedString(string: "\n"))
        }

        let userInfo = note.userInfo! as! [String: String]
        let message = userInfo[ChatWindowControllerMessageKey]!

        let logLine = NSAttributedString(string: message)
        mutableLog.appendAttributedString(logLine)

        log = mutableLog.copy() as! NSAttributedString

        textView.scrollRangeToVisible(NSRange(location: log.length, length: 0))
    }

    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
}
