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
import FirebaseAnalytics
class ShareViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    //@IBOutlet weak var screenshotPreview: UIImageView!
    @IBOutlet weak var moreView: UIStackView!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var share_frame: UIImageView!
    var imageToShow: UIImage!
    var quoteToShow: String!
    var authorToShow: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set UI font
        var font = Display_Font(font_size: 18).getUIFont()
        
        quote.font = font
        
        font = Display_Font(font_size: 14).getUIFont()
        
        author.font = font
        
        
        if imageToShow != nil
        {
         //   screenshotPreview.image = imageToShow
        }else
        {
       //     screenshotPreview.image = UIImage(named: "icon_notification")
        }
        
        
        
        if let color = UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.colorForKey(key: "BackgroundColor")
        {
            fullView.backgroundColor = color
        }
        
        author.textColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0)
        
        //StoreKit().requ
      //  SKStoreReviewController.requestReview()
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    

    @IBAction func optionTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            
            Analytics.logEvent("share_vc_album", parameters: nil)
            
            print("save to album")
            
            let image = takeScreenshot(of: fullView)
            
            alertViewHandler().alert(title: "已存至相簿", body: "", iconText: "📖")
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageWasSaved), nil)
        case 1:
            print("save to ig post")
            
            let image = takeScreenshot(of: fullView)
            
            
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageWasSaved_instagram), nil)
            postImage(image: image)
            
        case 2:
            print("save to ig post")
            
            Analytics.logEvent("share_vc_IG", parameters: nil)
            
            guard let imagePNGData = takeScreenshot(of: fullView).pngData() else { return }
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
            
        case 3:
            print("more")
            
            Analytics.logEvent("share_vc_more", parameters: nil)
            
            let items = [takeScreenshot(of: fullView)]
            let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
            ac.completionWithItemsHandler  = { activity, completed, items, error in
                if !completed {
                    // handle task not completed
                    Analytics.logEvent("share_vc_more_failed", parameters: nil)
                    return
                }
                Analytics.logEvent("share_vc_more_success", parameters: nil)
            }
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
        //UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    @objc func imageWasSaved_instagram(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        postImage(image: image)
        //UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        print(quoteToShow)
        //stringByReplacingOccurrencesOfString(", ", withString: "\n")
        quote.text = quoteToShow.replacingOccurrences(of: "，", with: "，\n").replacingOccurrences(of: "。", with: "。\n")
        author.text = authorToShow
        
        
        //storyly
    
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
    @IBAction func templateTapped(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            share_frame.isHidden = false
            author.textColor = UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1.0)
        case 1:
            share_frame.isHidden = true
            author.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        default:
            share_frame.isHidden = false
        }
        
    }
    
     
    @IBOutlet weak var saveToAlbum: UIImageView!
    
    func takeScreenshot(of view: UIView) -> UIImage {
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
    
    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram://"
    private let kUTI = "com.instagram.photo" //"com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.ig"//"instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    func postImage(image: UIImage, result:((Bool)->Void)? = nil) {
         guard let instagramURL = NSURL(string: "instagram://app") else {
             if let result = result {
                 result(false)
             }
             return
         }
         
         // let image = image.scaleImageWithAspectToWidth(640)
         
         do {
             try PHPhotoLibrary.shared().performChangesAndWait {
                 let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                 
                 let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                 let shareURL = "instagram://library?LocalIdentifier=" + assetID
                 
                 if UIApplication.shared.canOpenURL(instagramURL as URL) {
                     if let urlForRedirect = NSURL(string: shareURL) {
                         UIApplication.shared.open(URL(string: "\(urlForRedirect)")!)
                     }
                 }
             }
         } catch {
             if let result = result {
                 result(false)
             }
         }
     }
}
