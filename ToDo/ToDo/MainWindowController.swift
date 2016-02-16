//
//  MainWindowController.swift
//  ToDo
//
//  Created by Edward Loveall on 2/16/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSTableViewDataSource {
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!

    var items = [String]()

    override var windowNibName: String {
        return "MainWindowController"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @IBAction func createNewItemWithName(sender: NSButton) {
        items.append(textField.stringValue)
        tableView.reloadData()
    }

    // MARK: - NSTableViewDataSource

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return items.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return items[row]
    }
}
