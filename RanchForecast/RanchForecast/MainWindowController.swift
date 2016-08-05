//
//  MainWindowController.swift
//  RanchForecast
//
//  Created by Edward Loveall on 8/3/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
  @IBOutlet var tableView: NSTableView!
  @IBOutlet var arrayController: NSArrayController!
  @IBOutlet var spinner: NSProgressIndicator!

  let fetcher = ScheduleFetcher()
  dynamic var courses: [Course] = []

  override var windowNibName: String? {
    return "MainWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    tableView.target = self
    tableView.doubleAction = #selector(MainWindowController.openClass(_:))
    spinner.startAnimation(nil)

    fetcher.fetchCoursesUsingCompletionHandler { (result) in
      switch result {
      case .Success(let courses):
        self.courses = courses
      case .Failure(let error):
        print("Got error: \(error)")
        self.courses = []
      }
      self.spinner.stopAnimation(nil)
    }
  }

  func openClass(sender: AnyObject!) {
    if let course = arrayController.selectedObjects.first as? Course {
      NSWorkspace.sharedWorkspace().openURL(course.url)
    }
  }
}
