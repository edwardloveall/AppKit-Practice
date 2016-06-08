import Cocoa

class Pasteboard {
    class func writeToPasteboard(value: Int) {
        let pasteboard = NSPasteboard.generalPasteboard()
        pasteboard.clearContents()
        pasteboard.writeObjects(["\(value)"])
    }

    class func readFromPasteboard() -> Int? {
        let pasteboard = NSPasteboard.generalPasteboard()
        let objects = pasteboard.readObjectsForClasses([NSString.self],
                                                       options: [:]) as! [String]
        if let string = objects.first {
            return Int(string)
        }

        return Int?.None
    }
}