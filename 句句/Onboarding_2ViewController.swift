//
//  Onboarding_2ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit

class Onboarding_2ViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ColorPicked(_ sender: UIButton) {
        
        backgroundView.backgroundColor = sender.backgroundColor
     //   UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor") as? UIColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if backgroundView.backgroundColor != .systemBackground
        {
            print("Color saved")
            UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundView.backgroundColor, forKey: "BackgroundColor")
        }else
        {
            print("default color")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
