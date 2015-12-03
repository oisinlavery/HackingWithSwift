//
//  DetailViewController.swift
//  project1-oisin
//
//  Created by Oisín Lavery on 9/28/15.
//  Copyright © 2015 Oisín Lavery. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {


  @IBOutlet weak var detailImageView: UIImageView!


  var detailItem: String? {
    didSet {
        // Update the view.
        self.configureView()
    }
  }

  func configureView() {
    // Update the user interface for the detail item.
    if let detail = self.detailItem {

      self.title = detail

      if let imageView = self.detailImageView {
        imageView.image = UIImage(named: detail)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.configureView()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")

  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = false
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func shareTapped() {
//    let vc = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [])
//    presentViewController(vc, animated: true, completion: nil)

    let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
    vc.setInitialText("Look at this great picture!")
    vc.addImage(detailImageView.image!)
    vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
    presentViewController(vc, animated: true, completion: nil)
  }


}

