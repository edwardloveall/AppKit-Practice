//
//  Document.swift
//  ZIPspector
//
//  Created by Edward Loveall on 9/19/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class Document: NSDocument, NSTableViewDataSource {
  @IBOutlet weak var tableView: NSTableView!
  var filenames = [String]()

  override init() {
    super.init()
  }

  override class func autosavesInPlace() -> Bool {
    return true
  }

  override var windowNibName: String? {
    return "Document"
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return filenames.count
  }

  func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    return filenames[row]
  }

  override func read(from url: URL, ofType typeName: String) throws {
    let filename = url.path
    let process = Process()
    let outPipe = Pipe()
    process.launchPath = "/usr/bin/zipinfo"
    process.arguments = ["-l", filename]
    process.standardOutput = outPipe

    process.launch()

    let fileHandle = outPipe.fileHandleForReading
    let data = fileHandle.readDataToEndOfFile()

    process.waitUntilExit()
    let status = process.terminationStatus
    if status != 0 {
      return
    }

    let string = String(data: data, encoding: String.Encoding.utf8)!
    filenames = string.components(separatedBy: "\n") as [String]

    Swift.print(filenames)
    tableView?.reloadData()
  }
}
