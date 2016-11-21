import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }


}

