//: Playground - noun: a place where people can play

import Cocoa

let date = NSDate()
date.description

let dateFormatter = NSDateFormatter()
dateFormatter.dateStyle = .MediumStyle
dateFormatter.timeStyle = .ShortStyle
dateFormatter.stringFromDate(date)

let ransom = 1_000_000
let numberFormatter = NSNumberFormatter()

numberFormatter.numberStyle = .CurrencyStyle
numberFormatter.stringFromNumber(ransom)

numberFormatter.maximumFractionDigits = 0
numberFormatter.stringFromNumber(ransom)