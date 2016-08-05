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

  let fetcher = ScheduleFetcher()
  dynamic var courses: [Course] = []

  override var windowNibName: String? {
    return "MainWindowController"
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    tableView.target = self
    tableView.doubleAction = #selector(MainWindowController.openClass(_:))

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

  func openClass(sender: AnyObject!) {
    if let course = arrayController.selectedObjects.first as? Course {
      NSWorkspace.sharedWorkspace().openURL(course.url)
    }
  }
}
