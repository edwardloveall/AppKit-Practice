import Cocoa
import GameplayKit

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
  @IBOutlet var tableView: NSTableView!
  @IBOutlet var guess: NSTextField!

  var answer = ""
  var guesses = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    startNewGame()
  }

  func numberOfRows(in tableView: NSTableView) -> Int {
    return guesses.count
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    guard let vw = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
          else { return nil }
    if tableColumn?.title == "Guess" {
      vw.textField?.stringValue = guesses[row]
    } else {
      vw.textField?.stringValue = result(for: guesses[row])
    }

    return vw
  }

  func result(for guess: String) -> String {
    var cows = 0
    var bulls = 0

    let guessLetters = Array(guess.characters)
    let answerLetters = Array(answer.characters)

    for (index, letter) in guessLetters.enumerated() {
      if letter == answerLetters[index] {
        bulls += 1
      } else if answerLetters.contains(letter) {
        cows += 1
      }
    }

    return "\(bulls)B \(cows)C"
  }

  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    return false
  }

  func startNewGame() {
    guess.stringValue = ""
    guesses.removeAll()
    answer = ""

    var numbers = Array(0...9)
    numbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: numbers) as! [Int]
    for _ in 0..<4 {
      answer.append(String(numbers.removeLast()))
    }

    tableView.reloadData()
  }

  @IBAction func submitGuess(_ sender: Any) {
    let guessString = guess.stringValue
    guard Set(guessString.characters).count == 4 else { return }

    let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
    guard guessString.rangeOfCharacter(from: badCharacters) == nil else { return }

    guesses.insert(guessString, at: 0)
    tableView.insertRows(at: IndexSet(integer: 0), withAnimation: .slideDown)

    let resultString = result(for: guessString)
    if resultString.contains("4B") {
      let alert = NSAlert()
      alert.messageText = "You win!"
      alert.informativeText = "Congratulations! Click OK to play again."

      alert.runModal()
      startNewGame()
    }
  }
}
