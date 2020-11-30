//
//  Onboarding_2ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit

class Onboarding_2ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var gray: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ColorPicked(_ sender: UIButton) {
        
        backgroundView.backgroundColor = sender.backgroundColor
        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
    }
    @IBAction func skip(_ sender: Any) {
        if backgroundView.backgroundColor != .systemBackground
        {
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
        }else
        {
            let default_color = gray.backgroundColor
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: default_color, forKey: "BackgroundColor")
        }
    }
}
