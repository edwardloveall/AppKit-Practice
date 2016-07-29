import Cocoa

private let font: NSFont = NSFont.userFixedPitchFontOfSize(12.0)!
private let textAttributes: [String: AnyObject] = [NSFontAttributeName: font]
private let lineHeight: CGFloat = font.capHeight * 2.0

class EmployeesPrintingView: NSView {
  var employees = [Employee]()
  var pageRect = NSRect()
  var linesPerPage: Int = 0
  var currentPage: Int = 0

  override var flipped: Bool {
    return true
  }

  init(employees: [Employee]) {
    super.init(frame: NSRect())
    self.employees = employees
  }

  required init?(coder: NSCoder) {
    fatalError("EmployeesPrintingView cannot be instantiated from a nib.")
  }

  override func knowsPageRange(range: NSRangePointer) -> Bool {
    let printOperation = NSPrintOperation.currentOperation()!
    let printInfo: NSPrintInfo = printOperation.printInfo

    pageRect = printInfo.imageablePageBounds
    let newFrame = NSRect(origin: CGPoint(), size: printInfo.paperSize)
    frame = newFrame

    linesPerPage = Int(pageRect.height / lineHeight)
    var rangeOut = NSRange(location: 1, length: 0)
    rangeOut.length = employees.count / linesPerPage
    if employees.count % linesPerPage > 0 {
      rangeOut.length += 1
    }
    range.memory = rangeOut

    return true
  }

  override func rectForPage(page: Int) -> NSRect {
    currentPage = page - 1
    return pageRect
  }

  override func drawRect(dirtyRect: NSRect) {
    var nameRect = NSRect(x: pageRect.minX,
                          y: 0,
                          width: 200.0,
                          height: lineHeight)
    var raiseRect = NSRect(x: nameRect.maxX,
                           y: 0,
                           width: 100.0,
                           height: lineHeight)
    let pageNumRect = NSRect(x: pageRect.minX,
                             y: pageRect.maxY - lineHeight,
                             width: 200.0,
                             height: lineHeight)

    let pageNumString = NSString(string: "\(currentPage + 1)")
    pageNumString.drawInRect(pageNumRect, withAttributes: textAttributes)

    for indexOnPage in 0..<linesPerPage {
      let indexInEmployees = currentPage * linesPerPage + indexOnPage
      if indexInEmployees >= employees.count {
        break
      }

      let employee = employees[indexInEmployees]

      nameRect.origin.y = pageRect.minY + CGFloat(indexOnPage) * lineHeight
      let employeeName = (employee.name ?? "")
      let indexAndName = NSString(string: "\(indexInEmployees) \(employeeName)")
      indexAndName.drawInRect(nameRect, withAttributes: textAttributes)

      raiseRect.origin.y = nameRect.minY
      let raiseString = NSString(format: "%4.1f%%", employee.raise * 100)
      raiseString.drawInRect(raiseRect, withAttributes: textAttributes)
    }
  }
}
