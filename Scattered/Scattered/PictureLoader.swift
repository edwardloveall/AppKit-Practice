import Cocoa

class PictureLoader {
  let enumerator: NSDirectoryEnumerator?
  var fileURLs = [NSURL]()
  let fileLimit: Int

  init(folderURL: NSURL, fileLimit: Int) {
    self.fileLimit = fileLimit
    let fileManager = NSFileManager()
    self.enumerator = fileManager.enumeratorAtURL(folderURL,
                                                  includingPropertiesForKeys: .None,
                                                  options: [],
                                                  errorHandler: nil)
    setupFileURLs()
  }

  func setupFileURLs() {
    while let url = enumerator?.nextObject() as? NSURL {
      var directoryValue: AnyObject?
      var isImage = false
      do {
        try url.getResourceValue(&directoryValue, forKey: NSURLIsDirectoryKey)
      } catch {
        continue
      }
      guard let directoryNumber = directoryValue as? NSNumber else {
        continue
      }

      let isDirectory = directoryNumber.boolValue
      if let _ = NSImage(contentsOfURL: url) {
        isImage = true
      }

      if isDirectory == false && isImage == true {
        fileURLs.append(url)
      }
    }

    fileURLs = Array(fileURLs[0..<fileLimit])
  }
}
