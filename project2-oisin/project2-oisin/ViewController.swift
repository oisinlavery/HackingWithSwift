//
//  ViewController.swift
//  project2-oisin
//
//  Created by Oisín Lavery on 9/29/15.
//  Copyright © 2015 Oisín Lavery. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

  @IBOutlet weak var button1: UIButton!
  @IBOutlet weak var button2: UIButton!
  @IBOutlet weak var button3: UIButton!

  var countries = [String]()
  var correctAnswer = 0
  var score = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1

    button1.layer.borderColor = UIColor.lightGrayColor().CGColor
    button2.layer.borderColor = UIColor.lightGrayColor().CGColor
    button3.layer.borderColor = UIColor.lightGrayColor().CGColor

    askQuestion(nil)
  }

  func askQuestion(action: UIAlertAction!) {
    countries = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(countries) as! [String]

    button1.setImage(UIImage(named: countries[0]), forState: .Normal)
    button2.setImage(UIImage(named: countries[1]), forState: .Normal)
    button3.setImage(UIImage(named: countries[2]), forState: .Normal)

    correctAnswer = GKRandomSource.sharedRandom().nextIntWithUpperBound(3)

    title = countries[correctAnswer].uppercaseString
  }

  @IBAction func buttonTapped(sender: UIButton) {

    var title: String

    if sender.tag == correctAnswer {
      title = "Correct"
      ++score
    } else {
      title = "Wrong"
      --score
    }

    let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .Alert)
    ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: askQuestion))
    presentViewController(ac, animated: true, completion: nil)
  }
}

