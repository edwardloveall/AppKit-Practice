//
//  DetailViewController.swift
//  Project1
//
//  Created by Edward Loveall on 11/1/16.
//  Copyright © 2016 Edward Loveall. All rights reserved.
//

import Cocoa

class DetailViewController: NSViewController {
  @IBOutlet var imageView: NSImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func imageSelected(name: String) {
    imageView.image = NSImage(named: name)
  }
}
