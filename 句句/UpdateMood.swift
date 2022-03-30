//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class UpdateMood: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var mood = "default"

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moodSelected(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            mood = "super-happy"
        case 2:
            mood = "happy"
        case 3:
            mood = "neutral"
        case 4:
            mood = "sad"
        case 5:
            mood = "super-sad"
        default:
            mood = "default"
        }
    }
    
    
}


