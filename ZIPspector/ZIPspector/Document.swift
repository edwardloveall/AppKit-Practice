import Cocoa

enum ArchiveUTI: String {
  case zip = "public.zip-archive"
  case tar = "public.tar-archive"
  case tgz = "org.gnu.gnu-zip-tar-archive"
}

class Document: NSDocument, NSTableViewDataSource {
  @IBOutlet weak var tableView: NSTableView!
  var filenames = [String]()

  override init() {
    super.init()
  }

  override class func autosavesInPlace() -> Bool {
    return true
  }

  override var windowNibName: String? {
    return "Document"
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return filenames.count
  }

  func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
    return filenames[row]
  }

  override func read(from url: URL, ofType typeName: String) throws {
    let filename = url.path
    let outPipe = Pipe()
    guard let utiType = ArchiveUTI(rawValue: typeName) else {
      Swift.print("Cannot open this file with \(typeName) UTI!")
      return
    }
    let process: Process = {
      switch utiType {
      case .zip:
        return configureZip()
      case .tar:
        return configureTar()
      case .tgz:
        return configureTgz()
      }
    }()

    process.arguments?.append(filename)
    process.standardOutput = outPipe

    process.launch()

    let fileHandle = outPipe.fileHandleForReading
    let data = fileHandle.readDataToEndOfFile()

    process.waitUntilExit()
    let status = process.terminationStatus
    if status != 0 {
      return
    }

    let string = String(data: data, encoding: String.Encoding.utf8)!
    filenames = string.components(separatedBy: "\n") as [String]

    Swift.print(filenames)
    tableView?.reloadData()
  }

  func configureZip() -> Process {
    let process = Process()
    process.launchPath = "/usr/bin/zipinfo"
    process.arguments = ["-l"]
    return process
  }

  func configureTar() -> Process {
    let process = Process()
    process.launchPath = "/usr/bin/tar"
    process.arguments = ["tf"]
    return process
  }

  func configureTgz() -> Process {
    let process = Process()
    process.launchPath = "/usr/bin/tar"
    process.arguments = ["tzf"]
    return process
  }
}
