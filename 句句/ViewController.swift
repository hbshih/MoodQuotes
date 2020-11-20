//
//  ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var backgroundHideenView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor") as? UIColor
        {
            screenView.backgroundColor = color
            backgroundHideenView.backgroundColor =  color
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareSegue"
        {
            if let VC = segue.destination as? ShareViewController
            {
                backgroundHideenView.isHidden = false
                let image = takeScreenshot(of: backgroundHideenView)
                
                backgroundHideenView.isHidden = true
                 //   VC.screenshotPreview.image = image
                
                VC.imageToShow = image
                
              //  VC.screenshotPreview.image = UIImage(named: "icon_notification")
            }
        }
    }
    
    // MARK: - Actions
      @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
          if let error = error {
              print(error.localizedDescription)
              return
          }

          print("Image was saved in the photo gallery")
          UIApplication.shared.open(URL(string:"photos-redirect://")!)
      }
        
      func takeScreenshot(of view: UIStackView) -> UIImage {
          UIGraphicsBeginImageContextWithOptions(
              CGSize(width: view.bounds.width, height: view.bounds.height),
              false,
              2
          )

          view.layer.render(in: UIGraphicsGetCurrentContext()!)
          let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()
    
        
    
   

    
    
       //   UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
        return screenshot
      }
        
      @objc func actionButtonTapped() {
          takeScreenshot(of: backgroundHideenView)
      }

}

