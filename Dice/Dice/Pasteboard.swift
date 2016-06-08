import Cocoa

class Pasteboard {
    class func writeToPasteboard(values: (int: Int, data: NSData)) {
        let pasteboard = NSPasteboard.generalPasteboard()
        let item = NSPasteboardItem()
        item.setString(String(values.int), forType: NSPasteboardTypeString)
        item.setData(values.data, forType: NSPasteboardTypePDF)
        pasteboard.clearContents()
        pasteboard.writeObjects([item])
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