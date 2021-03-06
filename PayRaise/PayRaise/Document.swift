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
                let actionName = NSLocalizedString("UNDO_ADD_EMPLOYEE",
                                                   comment: "The menu title for reverting the Add Employee action")
                undo.setActionName(actionName)
            }
        }

        employees.append(employee)
    }

    func removeObjectFromEmployeesAtIndex(index: Int) {
        let employee = employees[index]

        if let undo = undoManager {
            undo.prepareWithInvocationTarget(self).insertObject(employee, inEmployeesAtIndex: index)

            if undo.undoing == false {
                let actionName = NSLocalizedString("UNDO_REMOVE_EMPLOYEE",
                                                   comment: "The menu title for reverting the Remove Employee action")
                undo.setActionName(actionName)
            }
        }

        employees.removeAtIndex(index)
    }

    @IBAction func removeEmployees(sender: AnyObject) {
        let selectedPeople: [Employee] = arrayController.selectedObjects as! [Employee]
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("REMOVE_MESSAGE", comment: "The remove alert's message text")
        let informativeFormat = NSLocalizedString("REMOVE_INFORMATIVE %d", comment: "The remove alert's informativeText")
        alert.informativeText = String(format: informativeFormat, selectedPeople.count)
        let removeButtonTitle = NSLocalizedString("REMOVE_DO", comment: "The remove alert's remove button")
        let removeNoRaiseTitle = NSLocalizedString("REMOVE_NO_RAISE", comment: "The remove alert's no raise button")
        let removeCancelTitle = NSLocalizedString("REMOVE_CANCEL", comment: "The remove alert's cancel button")
        alert.addButtonWithTitle(removeButtonTitle)
        alert.addButtonWithTitle(removeNoRaiseTitle)
        alert.addButtonWithTitle(removeCancelTitle)
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

    override func printOperationWithSettings(printSettings: [String : AnyObject]) throws -> NSPrintOperation {
        let employeesPrintingView = EmployeesPrintingView(employees: employees)
        let printInfo: NSPrintInfo = self.printInfo
        let printOperation = NSPrintOperation(view: employeesPrintingView,
                                              printInfo: printInfo)
        return printOperation
    }
}
