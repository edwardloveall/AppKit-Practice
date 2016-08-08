import Foundation

class XMLParser: NSObject, NSXMLParserDelegate {
  let parser: NSXMLParser
  var courseDicts: [[String: String]] = []
  var currentDict: [String: String] = [:]
  var elementHierarchy = [String]()

  init(data xmlData: NSData) {
    parser = NSXMLParser(data: xmlData)
    super.init()
    parser.delegate = self
  }

  func parse() -> [[String: String]] {
    parser.parse()
    return courseDicts
  }

  func parser(parser: NSXMLParser,
              didStartElement elementName: String,
              namespaceURI: String?,
              qualifiedName qName: String?,
              attributes attributeDict: [String : String]) {
    elementHierarchy.append(elementName)
    if let href = attributeDict["href"] {
      currentDict["href"] = href
    }
  }

  func parser(parser: NSXMLParser, foundCharacters string: String) {
    guard let lastElement = elementHierarchy.last else {
      return
    }
    let inClass = elementHierarchy.contains("class") &&
                  elementHierarchy.last != "class"
    let empty = currentDict[lastElement] == nil

    if inClass && empty {
      currentDict[lastElement] = string
    }
  }

  func parser(parser: NSXMLParser,
              didEndElement elementName: String,
              namespaceURI: String?,
              qualifiedName qName: String?) {
    elementHierarchy.popLast()
    if elementName == "class" {
      courseDicts.append(currentDict)
      currentDict = [:]
    }
  }
}