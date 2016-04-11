//
//  Document.swift
//  PayRaise
//
//  Created by Edward Loveall on 2/29/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

private var KVOContext = 0

class Document: NSDocument, NSWindowDelegate {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var arrayController: NSArrayController!

    var employees: [Employee] = [] {
        willSet {
            for employee in employees {
                stopObservingEmployee(employee)
            }
        }
        didSet {
            for employee in employees {
                startObservingEmployee(employee)
            }
        }
    }

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func dataOfType(typeName: String) throws -> NSData {
        tableView.window?.endEditingFor(nil)
        return NSKeyedArchiver.archivedDataWithRootObject(employees)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        employees = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Employee]
    }

    @IBAction func addEmployee(sender: NSButton) {
        let windowController = windowControllers[0]
        let window = windowController.window!

        let endedEditing = window.makeFirstResponder(window)
        if !endedEditing {
            print("Unable to end editing.")
            return
        }

        if let undo = undoManager {
            if undo.groupingLevel > 0 {
                undo.endUndoGrouping()
                undo.beginUndoGrouping()
            }
        }

        let employee = arrayController.newObject() as! Employee
        arrayController.addObject(employee)
        arrayController.rearrangeObjects()
        let sortedEmployees = arrayController.arrangedObjects as! [Employee]
        let row = sortedEmployees.indexOf(employee)!
        tableView.editColumn(0, row: row, withEvent: nil, select: true)
    }

    func insertObject(employee: Employee, inEmployeesAtIndex index: Int) {
        if let undo = undoManager {
            undo.prepareWithInvocationTarget(self).removeObjectFromEmployeesAtIndex(employees.count)

            if undo.undoing == false {
                undo.setActionName("Add Person")
            }
        }

        employees.append(employee)
    }

    @IBAction func removeEmployees(sender: NSButton) {
        let selectedPeople: [Employee] = arrayController.selectedObjects as! [Employee]
        let alert = NSAlert()
        alert.messageText = "Do you really want to remove these people?"
        alert.informativeText = "\(selectedPeople.count) will be removed."
        alert.addButtonWithTitle("Remove")
        alert.addButtonWithTitle("Cancel")
        let window = sender.window!
        alert.beginSheetModalForWindow(window, completionHandler: { (response) -> Void in
            switch response {
            case NSAlertFirstButtonReturn:
                self.arrayController.remove(nil)
            default: break
            }
        })
    }

    func removeObjectFromEmployeesAtIndex(index: Int) {
        let employee = employees[index]

        if let undo = undoManager {
            undo.prepareWithInvocationTarget(self).insertObject(employee, inEmployeesAtIndex: index)

            if undo.undoing == false {
                undo.setActionName("Remove Person")
            }
        }

        employees.removeAtIndex(index)
    }

    func startObservingEmployee(employee: Employee) {
        employee.addObserver(self, forKeyPath: "name", options: .Old, context: &KVOContext)
        employee.addObserver(self, forKeyPath: "raise", options: .Old, context: &KVOContext)
    }

    func stopObservingEmployee(employee: Employee) {
        employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
        employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context != &KVOContext {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }

        if let keyPath = keyPath, object = object, change = change {
            var oldValue = change[NSKeyValueChangeOldKey]
            if oldValue is NSNull {
                oldValue = nil
            }

            if let undo = undoManager {
                undo.prepareWithInvocationTarget(object).setValue(oldValue, forKeyPath: keyPath)
            }
        }
    }

    func windowWillClose(notification: NSNotification) {
        employees = []
    }
}
