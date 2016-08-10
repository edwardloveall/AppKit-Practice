import Foundation

class Course: NSObject {
  let title: String
  let url: NSURL
  let nextStartDate: NSDate

  init(title: String, url: NSURL, nextStartDate: NSDate) {
    self.title = title
    self.url = url
    self.nextStartDate = nextStartDate
    super.init()
  }
}

func ==(lhs: Course, rhs: Course) -> Bool {
  return lhs.title == rhs.title &&
         lhs.url == rhs.url &&
         lhs.nextStartDate == rhs.nextStartDate
}
