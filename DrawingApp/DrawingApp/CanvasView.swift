//
//  CanvasView.swift
//  DrawingApp
//
//  Created by Edward Loveall on 5/9/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class CanvasView: NSView {
    var ovals = [Oval]()
    var currentStart = CGPoint.zero
    var currentDraggedPosition = CGPoint.zero
    var currentOval: Oval?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        NSColor.whiteColor().set()
        NSBezierPath.fillRect(bounds)

        NSColor.grayColor().set()

        for oval in ovals {
            oval.draw()
        }

        if let oval = currentOval {
            oval.draw()
        }
    }

    override func mouseDown(theEvent: NSEvent) {
        currentStart = convertPoint(theEvent.locationInWindow, toView: nil)
        currentOval = Oval(origin: currentStart)
    }

    override func mouseDragged(theEvent: NSEvent) {
        currentDraggedPosition = convertPoint(theEvent.locationInWindow, toView: nil)
        let size = makeSize()

        if let oval = currentOval {
            oval.size = size
        }
        needsDisplay = true
    }

    override func mouseUp(theEvent: NSEvent) {
        currentDraggedPosition = convertPoint(theEvent.locationInWindow, toView: nil)
        let size = makeSize()

        if let oval = currentOval {
            oval.size = size
            ovals.append(oval)
            currentOval = .None
        }
        needsDisplay = true
    }

    func makeSize() -> CGSize {
        return CGSize(width: currentDraggedPosition.x - currentStart.x,
                      height: currentDraggedPosition.y - currentStart.y)
    }
}
