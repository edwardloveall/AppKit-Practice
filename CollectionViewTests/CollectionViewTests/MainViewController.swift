import Cocoa

class MainViewController: NSViewController {
  var titles = [String]()
  var collectionView: NSCollectionView?

  override func viewDidLoad() {
    super.viewDidLoad()

    titles = ["Banana", "Apple", "Strawberry", "Cherry", "Grape", "Tangerine"]
    collectionView = NSCollectionView(frame: view.frame)
    collectionView?.itemPrototype = CollectionViewItem()
    collectionView?.content = self.titles
    collectionView?.autoresizingMask = NSAutoresizingMaskOptions([
      .viewWidthSizable,
      .viewMaxXMargin,
      .viewMinYMargin,
      .viewHeightSizable,
      .viewMaxYMargin
    ])

    for (index, _) in titles.enumerated() {
      guard
        let item = self.collectionView!.item(at: index) as? CollectionViewItem
      else {
        fatalError("could not get item")
      }
      item.getView().setButtonTitle(titles[index])
    }

    self.view.addSubview(collectionView!)
  }
}
