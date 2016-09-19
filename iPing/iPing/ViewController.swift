//
//  ViewController.swift
//  iPing
//
//  Created by Edward Loveall on 9/19/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  @IBOutlet var outputView: NSTextView!
  @IBOutlet weak var hostField: NSTextField!
  @IBOutlet weak var startButton: NSButton!

  var process: Process?
  var pipe: Pipe?
  var fileHandle: FileHandle?

  @IBAction func togglePinging(sender: NSButton) {
    if let process = process {
      process.interrupt()
    } else {

      let process = Process()
      let pipe = Pipe()
      process.launchPath = "/sbin/ping"
      process.arguments = ["-c10", hostField.stringValue]
      process.standardOutput = pipe
      let fileHandle = pipe.fileHandleForReading

      self.process = process
      self.pipe = pipe
      self.fileHandle = fileHandle

      let notificationCenter = NotificationCenter.default
      notificationCenter.removeObserver(self)
      notificationCenter.addObserver(self,
                                     selector: #selector(receiveDataReadyNotification(notification:)),
                                     name: FileHandle.readCompletionNotification,
                                     object: fileHandle)
      notificationCenter.addObserver(self,
                                     selector: #selector(receiveTaskTerminatedNotification(notification:)),
                                     name: Process.didTerminateNotification,
                                     object: process)

      process.launch()
      outputView.string = ""
      fileHandle.readInBackgroundAndNotify()
    }
  }

  func appendData(data: Data) {
    guard let string = String(data: data, encoding: String.Encoding.utf8) else {
      print("could not read data from pipe")
      return
    }
    guard let textStorage = outputView.textStorage else {
      print("could not get textView's textStorage")
      return
    }

    let endRange = NSRange(location: textStorage.length, length: 0)
    textStorage.replaceCharacters(in: endRange, with: string)
  }

  func receiveDataReadyNotification(notification: Notification) {
    guard let data = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data else {
      print("could not get notification data")
      return
    }

    let byteCount = data.count
    print("received data: \(byteCount) bytes")
    if byteCount > 0 {
      self.appendData(data: data)
    }

    if let fileHandle = fileHandle {
      fileHandle.readInBackgroundAndNotify()
    }
  }

  func receiveTaskTerminatedNotification(notification: Notification) {
    print("task terminiated")
    process = nil
    pipe = nil
    fileHandle = nil
    startButton.state = 0
  }
}
