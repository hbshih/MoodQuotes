//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class UpdateFontViewController: UIViewController {

    @IBOutlet weak var exampleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let font = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.string(forKey: "userFont")
        {
            selectedFont = font
        }
    }
    
    var selectedFont: String?
    
    @IBAction func fontSelected(_ sender: UIButton) {
        exampleLabel.text = sender.currentTitle
        exampleLabel.font = sender.titleLabel?.font
        switch sender.tag {
        case 1:
            selectedFont = "I.Ngaan"
        case 2:
            selectedFont = "JasonHandwriting5"
        case 3:
            selectedFont = "I.PenCrane-B"
        case 4:
            selectedFont = "QIJIC"
        case 5:
            selectedFont = "jf-openhuninn-1.1"
        default:
            print("null")
        }
    }
    


}
