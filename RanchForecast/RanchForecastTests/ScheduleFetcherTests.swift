import XCTest
@testable import RanchForecast

class ScheduleFetcherTests: XCTestCase {
  var fetcher: ScheduleFetcher!

  override func setUp() {
    super.setUp()
    fetcher = ScheduleFetcher()
  }

  override func tearDown() {
    fetcher = nil
    super.tearDown()
  }

  func testCreateCourseFromValidDictionary() {
    let course: Course! = fetcher.courseFromDictionary(Constants.validCourseDict)

    XCTAssertNotNil(course)
    XCTAssertEqual(course.title, Constants.title)
    XCTAssertEqual(course.url, Constants.url)
    XCTAssertEqual(course.nextStartDate, Constants.date)
  }

  func testResultFromValidHTTPResponseAndValidData() {
    let result = fetcher.resultFromData(Constants.jsonData,
                                        response: Constants.okResponse,
                                        error: nil)
    switch result {
    case .Success(let courses):
      XCTAssert(courses.count == 1)
      let course = courses[0]
      XCTAssertEqual(course.title, Constants.title)
      XCTAssertEqual(course.url, Constants.url)
      XCTAssertEqual(course.nextStartDate, Constants.date)
    default:
      XCTFail("Result contains Failure, but Sucess was expected.")
    }
  }
}
