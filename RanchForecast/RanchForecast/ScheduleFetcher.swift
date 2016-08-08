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
    guard let url = NSURL(string: "http://bookapi.bignerdranch.com/courses.xml") else {
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
          let parser = XMLParser(data: data)
          let courseDicts = parser.parse()
          result = FetchCoursesResult { self.coursesFromDictionaries(dicts: courseDicts) }
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
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm::ss Z"

    guard let title = dict["offering"] as? String else {
      print("could not get title")
      return nil
    }

    guard let urlString = dict["href"] as? String,
          let url = NSURL(string: urlString) else {
      print("could not parse URL")
      return nil
    }

    guard let nextStartDateString = dict["begin"] as? String,
          let nextStartDate = dateFormatter.dateFromString(nextStartDateString) else {
      print("could not parse startDate")
      return nil
    }

    return Course(title: title, url: url, nextStartDate: nextStartDate)
  }

  func coursesFromDictionaries(dicts courseDicts: [Dictionary<String, String>]) -> [Course] {
    var courses: [Course] = []
    for courseDict in courseDicts {
      if let course = courseFromDictionary(courseDict) {
        courses.append(course)
      }
    }
    return courses
  }
}
