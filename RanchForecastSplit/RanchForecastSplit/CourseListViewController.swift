import Cocoa

class CourseListViewController: NSViewController {
  dynamic var courses: [Course] = []
  let fetcher = ScheduleFetcher()
  @IBOutlet var arrayController: NSArrayController!

  override func viewDidLoad() {
    super.viewDidLoad()
    fetcher.fetchCoursesUsingCompletionHandler { (result) in
      switch result {
      case .Success(let courses):
        print("Got courses: \(courses)")
        self.courses = courses
      case .Failure(let error):
        print("Got error: \(error)")
        NSAlert(error: error).runModal()
        self.courses = []
      }
    }
  }
}