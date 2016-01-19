//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Edward Loveall on 1/19/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var todoField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var todoTable: NSTableView!
    var todoItems: [String]

    func applicationDidFinishLaunching(aNotification: NSNotification) {}
    func applicationWillTerminate(aNotification: NSNotification) {}

    override init() {
        todoItems = [String]()
    }

    @IBAction func addItem(sender: AnyObject) {
        let todoString = todoField.stringValue
        todoItems.append(todoString)
        todoField.stringValue = ""
        todoTable.reloadData()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return todoItems.count
    }

    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return todoItems[row]
    }

    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        guard let changedItem = object as? String else {
            return
        }
        todoItems[row] = changedItem
        todoTable.reloadData()
    }
}
