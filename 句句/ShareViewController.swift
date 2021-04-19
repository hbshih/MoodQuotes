//
//  ShareViewController.swift
//  句句
//
//  Created by Ben on 2020/11/18.
//

import UIKit
import AVKit
import Photos
import StoreKit
//import FirebaseAnalytics

class ShareViewController: UIViewController {

    @IBOutlet weak var screenshotPreview: UIImageView!
    @IBOutlet weak var moreView: UIStackView!
    var imageToShow: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageToShow != nil
        {
            screenshotPreview.image = imageToShow
        }else
        {
            screenshotPreview.image = UIImage(named: "icon_notification")
        }
        //StoreKit().requ
        SKStoreReviewController.requestReview()
    }

    @IBAction func optionTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            
            // Analytics.logEvent("share_vc_album", parameters: nil)
            
            print("save to album")
            
            UIImageWriteToSavedPhotosAlbum(screenshotPreview.image!, self, #selector(imageWasSaved), nil)
            
        case 1:
            print("save to ig")
            
            //Analytics.logEvent("share_vc_IG", parameters: nil)
            
            guard let imagePNGData = screenshotPreview.image?.pngData() else { return }
               guard let instagramStoryUrl = URL(string: "instagram-stories://share") else {
            
                return
               }
            
            if UIApplication.shared.canOpenURL(instagramStoryUrl)
            {
                
            }else
            {
                let controller = UIAlertController(title: "打不開IG", message: "建議您直接存入相簿後再分享", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "好", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            }
            
               let itemsToShare: [[String: Any]] = [["com.instagram.sharedSticker.backgroundImage": imagePNGData]]
               let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
               UIPasteboard.general.setItems(itemsToShare, options: pasteboardOptions)
               UIApplication.shared.open(instagramStoryUrl, options: [:], completionHandler: nil)
            
        case 2:
            print("more")
            
            //Analytics.logEvent("share_vc_more", parameters: nil)
            
            let items = [screenshotPreview.image]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
            
        default:
            print("more")
        }
    }
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        print("Image was saved in the photo gallery")
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {

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
