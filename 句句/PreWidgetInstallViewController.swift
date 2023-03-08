//
//  PreWidgetInstallViewController.swift
//  句句
//
//  Created by Ben on 2023/3/8.
//

import UIKit

class PreWidgetInstallViewController: UIViewController {

    @IBOutlet weak var ViewWidget: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor")
        {
            ViewWidget.backgroundColor = color
        }else
        {
            ViewWidget.backgroundColor = UIColor(red: 239/255, green: 216/255, blue: 216/255, alpha: 1.0)
           // UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundColor.backgroundColor, forKey: "BackgroundColor")
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TutorialSegue"
        {
            if let VC = segue.destination as? TutorialViewController
            {
                VC.navigateToHome = true
            }
        }
    }

}
