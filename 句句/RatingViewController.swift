//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var exampleFont: UILabel!
    @IBOutlet weak var exampleBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        exampleFont.font = Display_Font(font_size: 32).getUIFont()
        let defaults = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!
        if let color = defaults.colorForKey(key: "BackgroundColor") as? UIColor
        {
            exampleBackground.backgroundColor = color
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func colorPicked(_ sender: UIButton) {
        
        exampleBackground.backgroundColor = sender.backgroundColor
        
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

extension RatingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
