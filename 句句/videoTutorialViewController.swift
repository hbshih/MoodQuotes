//
//  videoTutorialViewController.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import UIKit

class videoTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageView = UIImageView(image: jeremyGif)
        imageView.tag = 100
        imageView.frame = CGRect(x: view.frame.width/4, y: 50.0, width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
        view.addSubview(imageView)
    }
    
    var isVideoOpen = false
    let jeremyGif = UIImage.gifImageWithName("ezgif-3-d2dbde6ebf9a")
    
    
    @IBAction func Done(_ sender: Any) {
        
        
        
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
