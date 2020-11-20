//
//  ShareViewController.swift
//  句句
//
//  Created by Ben on 2020/11/18.
//

import UIKit

class ShareViewController: UIViewController {

    @IBOutlet weak var screenshotPreview: UIImageView!
    var imageToShow: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            // screenshotPreview.image = UIImage(named: "icon_notification")

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imageToShow != nil
        {
            screenshotPreview.image = imageToShow
        }else
        {
            screenshotPreview.image = UIImage(named: "icon_notification")
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var saveToAlbum: UIImageView!
    
}
