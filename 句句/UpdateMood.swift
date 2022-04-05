//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class UpdateMood: UIViewController {

    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var mood = "default"

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func moodSelected(_ sender: UIButton) {
        moodImage.image = sender.currentImage
        switch sender.tag {
        case 1:
            mood = "super-happy"
            moodLabel.text = "有夠開心"
        case 2:
            mood = "happy"
            moodLabel.text = "開心"
        case 3:
            mood = "neutral"
            moodLabel.text = "馬馬虎虎"
        case 4:
            mood = "sad"
            moodLabel.text = "難過"
        case 5:
            mood = "super-sad"
            moodLabel.text = "有夠難過"
        default:
            mood = "default"
        }
    }
    
    
}


