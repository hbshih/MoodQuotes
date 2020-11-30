//
//  videoTutorialViewController.swift
//  句句
//
//  Created by Ben on 2020/11/27.
//

import UIKit

class videoTutorialViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gifLoader: UIImageView!
    @IBOutlet weak var gifView: UIView!
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
        
      //  gifLoader.loadGif(name: "ezgif-3-d2dbde6ebf9a")
/*
        // Do any additional setup after loading the view.
        let imageView = UIImageView(image: jeremyGif)
        imageView.tag = 100
        imageView.contentMode = .center
        imageView.contentMode = .scaleAspectFit
        
        imageView.frame.size = CGSize(width: gifView.frame.width, height: gifView.frame.height)
     //   imageView.frame = CGRect(x: 0, y: 0, width: gifView.frame.width, height: gifView.frame.height)
     //   imageView.frame = CGRect(
        gifView.addSubview(imageView)*/
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
