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
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
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
