import Cocoa

class CollectionViewItem: NSCollectionViewItem {
  var itemView: ItemView?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func loadView() {
    self.itemView = ItemView(frame: NSZeroRect)
    self.view = self.itemView!
  }

  func getView() -> ItemView {
    return itemView!
  }
}