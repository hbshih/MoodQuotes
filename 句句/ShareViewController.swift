//
//  ShareViewController.swift
//  句句
//
//  Created by Ben on 2020/11/18.
//

import UIKit
import AVKit
import Photos

class ShareViewController: UIViewController {

    @IBOutlet weak var screenshotPreview: UIImageView!
    @IBOutlet weak var moreView: UIStackView!
    var imageToShow: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func optionTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("save to album")
            
            UIImageWriteToSavedPhotosAlbum(screenshotPreview.image!, self, #selector(imageWasSaved), nil)
            
        case 1:
            print("save to ig")
            
            guard let imagePNGData = screenshotPreview.image?.pngData() else { return }
               guard let instagramStoryUrl = URL(string: "instagram-stories://share") else { return }
               guard UIApplication.shared.canOpenURL(instagramStoryUrl) else { return }

               let itemsToShare: [[String: Any]] = [["com.instagram.sharedSticker.backgroundImage": imagePNGData]]
               let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
               UIPasteboard.general.setItems(itemsToShare, options: pasteboardOptions)
               UIApplication.shared.open(instagramStoryUrl, options: [:], completionHandler: nil)
            
        case 2:
            print("more")
            
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
