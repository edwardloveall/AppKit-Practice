import Cocoa

class MainSplitViewController: NSSplitViewController,
                               CourseListViewControllerDelegate {
  var masterViewController: CourseListViewController {
    let masterItem = splitViewItems[0]
    return masterItem.viewController as! CourseListViewController
  }

  var detailViewController: WebViewController {
    let detailItem = splitViewItems[1]
    return detailItem.viewController as! WebViewController
  }

  let defaultURL = NSURL(string: "http://www.bignerdranch.com")!

  override func viewDidLoad() {
    super.viewDidLoad()
    masterViewController.delegate = self
    detailViewController.loadURL(defaultURL)
  }

  func courseListViewController(viewController: CourseListViewController,
                                selectedCourse: Course?) {
    if let course = selectedCourse {
      detailViewController.loadURL(course.url)
    } else {
      detailViewController.loadURL(defaultURL)
    }
  }
}