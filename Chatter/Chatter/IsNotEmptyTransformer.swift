//
//  IsNotEmptyTransformer.swift
//  Chatter
//
//  Created by Edward Loveall on 4/13/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

@objc(IsNotEmptyTransformer) class IsNotEmptyTransformer: NSValueTransformer {
    override func transformedValue(value: AnyObject?) -> AnyObject? {
        guard let value = value as? String else {
            return false
        }

        return !value.isEmpty
    }
}
