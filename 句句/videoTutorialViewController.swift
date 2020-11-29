//
//  videoTutorialViewController.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import UIKit

class videoTutorialViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor")
        {
            print(color)
            view.backgroundColor = color
        }else
        {
        
            view.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 230/255, alpha: 1.0)
           // UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.setColor(color: backgroundColor.backgroundColor, forKey: "BackgroundColor")
            
        }

        // Do any additional setup after loading the view.
      //  imageView = UIImageView(image: jeremyGif)
        //imageView.tag = 100
        //imageView.frame = CGRect(x: view.frame.width/4, y: 50.0, width: self.view.frame.size.width/1.2, height: self.view.frame.size.height/1.2)
        //view.addSubview(imageView)
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
