import Cocoa

class Roller {
  let dieView: DieView
  let window: NSWindow?
  var rollsRemaining = 0

  init(dieView: DieView, window: NSWindow?) {
    self.dieView = dieView
    self.window = window
  }

  func roll() {
    rollsRemaining = dieView.numberOfTimesToRoll
    NSTimer.scheduledTimerWithTimeInterval(
      0.15,
      target: self,
      selector: #selector(Roller.rollTick),
      userInfo: nil,
      repeats: true
    )
    window?.makeFirstResponder(nil)
  }

  @objc func rollTick(sender: NSTimer) {
    let lastDotCount = dieView.dotCount
    while lastDotCount == dieView.dotCount {
      dieView.randomize()
    }
    rollsRemaining -= 1
    if rollsRemaining == 0 {
      sender.invalidate()
      window?.makeFirstResponder(dieView)
    }
  }
}