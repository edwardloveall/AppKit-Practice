//
//  Oval.swift
//  DrawingApp
//
//  Created by Edward Loveall on 5/9/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class Oval {
    var origin: CGPoint
    var size = CGSize.zero

    init(origin: CGPoint) {
        self.origin = origin
    }

    func draw() {
        let path = NSBezierPath()
        path.appendBezierPathWithOvalInRect(boundingBox())
        path.fill()
    }

    private func boundingBox() -> CGRect {
        return CGRect(origin: origin, size: size)
    }
}
