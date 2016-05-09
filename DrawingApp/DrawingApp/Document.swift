//
//  Document.swift
//  DrawingApp
//
//  Created by Edward Loveall on 5/9/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    override init() {
        super.init()
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        return "Document"
    }
}
