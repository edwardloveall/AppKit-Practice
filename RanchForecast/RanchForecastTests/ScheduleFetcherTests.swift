import XCTest
@testable import RanchForecast

class ScheduleFetcherTests: XCTestCase {
  var fetcher: ScheduleFetcher!
  let expectedCourse = Course(title: Constants.title,
                              url: Constants.url,
                              nextStartDate: Constants.date!)

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
    XCTAssert(course == expectedCourse)
  }

  func testResultFromValidHTTPResponseAndValidData() {
    let result = fetcher.resultFromData(Constants.jsonData,
                                        response: Constants.okResponse,
                                        error: nil)
    switch result {
    case .Success(let courses):
      XCTAssert(courses.count == 1)
      let course = courses[0]
      XCTAssert(course == expectedCourse)
    default:
      XCTFail("Result contains Failure, but Sucess was expected.")
    }
  }
}
