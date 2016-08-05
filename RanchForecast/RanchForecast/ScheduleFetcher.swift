import Foundation

class ScheduleFetcher {
  let session: NSURLSession
  enum FetchCoursesResult {
    init(throwingClosure: () throws -> [Course]) {
      do {
        let courses = try throwingClosure()
        self = .Success(courses)
      } catch {
        self = .Failure(error as NSError)
      }
    }

    case Success([Course])
    case Failure(NSError)
  }

  init() {
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    session = NSURLSession(configuration: config)
  }

  func fetchCoursesUsingCompletionHandler(completionHandler: (FetchCoursesResult) -> Void) {
    guard let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.json") else {
      print("URL could not be formed")
      exit(1)
    }
    let request = NSURLRequest(URL: url)
    let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
      var result: FetchCoursesResult

      if data == nil, let error = error {
        result = .Failure(error)
      } else if let response = response as? NSHTTPURLResponse,
                let data = data {
        print("\(data.length) bytes, HTTP \(response.statusCode)")
        if response.statusCode == 200 {
          result = FetchCoursesResult { try self.coursesFromData(data) }
        } else {
          let error = self.errorWithCode(1, localizedDescription: "Bad status code \(response.statusCode)")
          result = .Failure(error)
        }
      } else {
        let error = self.errorWithCode(1, localizedDescription: "Unexpected response object")
        result = .Failure(error)
      }

      NSOperationQueue.mainQueue().addOperationWithBlock({
        completionHandler(result)
      })
    })

    task.resume()
  }

  func errorWithCode(code: Int, localizedDescription: String) -> NSError {
    return NSError(domain: "ScheduleFetcher",
                   code: code,
                   userInfo: [NSLocalizedDescriptionKey: localizedDescription])
  }

  func courseFromDictionary(dict: NSDictionary) -> Course? {
    let title = dict["title"] as! String
    let urlString = dict["url"] as! String
    let upcomingArray = dict["upcoming"] as! [NSDictionary]
    let nextUpcomingDict = upcomingArray.first!
    let nextStartDateString = nextUpcomingDict["start_date"] as! String

    let url = NSURL(string: urlString)!

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"
    let nextStartDate = dateFormatter.dateFromString(nextStartDateString)!

    return Course(title: title, url: url, nextStartDate: nextStartDate)
  }

  func coursesFromData(data: NSData) throws -> [Course] {
    let topLevelDict = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
    let courseDicts = topLevelDict["courses"] as! [NSDictionary]
    var courses: [Course] = []
    for courseDict in courseDicts {
      if let course = courseFromDictionary(courseDict) {
        courses.append(course)
      }
    }
    return courses
  }
}
