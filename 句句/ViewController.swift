//
//  ViewController.swift
//  句句
//
//  Created by Ben on 2020/11/14.
//

import UIKit
import FirebaseDatabase

var global_quote: String = ""

class ViewController: UIViewController {

    @IBOutlet weak var frontQuote: UILabel!
    @IBOutlet weak var hiddenQuote: UILabel!
    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var backgroundHideenView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ref = Database.database().reference()
        
        DispatchQueue.main.async { [self] in
            //  let userID = Auth.auth().currentUser?.uid
            self.ref.child("Quote of the Day").observe(.value) { (snapshot) in
                  if let value = snapshot.value as? NSDictionary
                  {
                
                      if let quote = value["Quote"] as? String
                      {
                          self.quote = quote
                          if let author = value["Author"] as? String
                          {
                              self.author = author
                            frontQuote.text = self.quote + "\n" + "— " + self.author
                            hiddenQuote.text = self.quote + "\n" + "— " + self.author
                            global_quote = frontQuote.text!
                          }
                      }
                  }
              }

        }

    }
    
    var ref: DatabaseReference!

    var quote: String = "今日App心情都太差了，沒有任何更新"
    var author: String = "— 斌"
    
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

