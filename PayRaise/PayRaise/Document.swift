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
  @IBOutlet weak var addEmployee: NSButton!
  @IBOutlet weak var removeEmployee: NSButton!
  @IBOutlet weak var view: NSView!

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
        addAutoLayoutConstraints()
    }

  func addAutoLayoutConstraints() {
    guard let scrollView = tableView.enclosingScrollView else {
      print("could not find table's scrollview")
      return
    }

    scrollView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint(item: addEmployee,
                       attribute: .Top,
                       relatedBy: .Equal,
                       toItem: view,
                       attribute: .Top,
                       multiplier: 1,
                       constant: 20).active = true
    NSLayoutConstraint(item: addEmployee,
                       attribute: .Leading,
                       relatedBy: .Equal,
                       toItem: scrollView,
                       attribute: .Trailing,
                       multiplier: 1,
                       constant: 8).active = true
    NSLayoutConstraint(item: removeEmployee,
                       attribute: .Top,
                       relatedBy: .Equal,
                       toItem: addEmployee,
                       attribute: .Bottom,
                       multiplier: 1,
                       constant: 8).active = true
    NSLayoutConstraint(item: removeEmployee,
                       attribute: .Leading,
                       relatedBy: .Equal,
                       toItem: scrollView,
                       attribute: .Trailing,
                       multiplier: 1,
                       constant: 8).active = true
    NSLayoutConstraint(item: removeEmployee,
                       attribute: .Width,
                       relatedBy: .Equal,
                       toItem: addEmployee,
                       attribute: .Width,
                       multiplier: 1,
                       constant: 0).active = true
    NSLayoutConstraint(item: scrollView,
                       attribute: .Top,
                       relatedBy: .Equal,
                       toItem: view,
                       attribute: .Top,
                       multiplier: 1,
                       constant: 20).active = true
    NSLayoutConstraint(item: scrollView,
                       attribute: .Leading,
                       relatedBy: .Equal,
                       toItem: view,
                       attribute: .Leading,
                       multiplier: 1,
                       constant: 20).active = true
    NSLayoutConstraint(item: scrollView,
                       attribute: .Width,
                       relatedBy: .GreaterThanOrEqual,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1,
                       constant: 200).active = true
    NSLayoutConstraint(item: scrollView,
                       attribute: .Height,
                       relatedBy: .GreaterThanOrEqual,
                       toItem: nil,
                       attribute: .NotAnAttribute,
                       multiplier: 1,
                       constant: 100).active = true
    NSLayoutConstraint(item: view,
                       attribute: .Trailing,
                       relatedBy: .Equal,
                       toItem: addEmployee,
                       attribute: .Trailing,
                       multiplier: 1,
                       constant: 20).active = true
    NSLayoutConstraint(item: view,
                       attribute: .Bottom,
                       relatedBy: .Equal,
                       toItem: scrollView,
                       attribute: .Bottom,
                       multiplier: 1,
                       constant: 20).active = true
    NSLayoutConstraint(item: view,
                       attribute: .Bottom,
                       relatedBy: .GreaterThanOrEqual,
                       toItem: removeEmployee,
                       attribute: .Bottom,
                       multiplier: 1,
                       constant: 20).active = true
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

    @IBAction func removeEmployees(sender: AnyObject) {
        let selectedPeople: [Employee] = arrayController.selectedObjects as! [Employee]
        let alert = NSAlert()
        if selectedPeople.count == 1 {
            if let name = selectedPeople.first?.name {
                alert.messageText = "Do you really want to remove \(name)?"
                alert.informativeText = "1 person will be removed."
            }
        } else {
            alert.messageText = "Do you really want to remove these people?"
            alert.informativeText = "\(selectedPeople.count) will be removed."
        }
        alert.addButtonWithTitle("Remove")
        alert.addButtonWithTitle("No raise")
        alert.addButtonWithTitle("Cancel")
        let window = sender.window!
        alert.beginSheetModalForWindow(window, completionHandler: { (response) -> Void in
            switch response {
            case NSAlertFirstButtonReturn:
                self.arrayController.remove(nil)
            case NSAlertSecondButtonReturn:
                self.removeRaiseForEmployees(selectedPeople)
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

    func removeRaiseForEmployees(employees: [Employee]) {
        for employee in employees {
            employee.raise = 0
        }
        tableView.reloadData()
    }

    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case #selector(self.removeEmployees(_:)):
            return !arrayController.selectedObjects.isEmpty
        default:
            return super.validateMenuItem(menuItem)
        }
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
