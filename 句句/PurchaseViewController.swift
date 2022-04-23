//
//  PurchaseViewController.swift
//  句句
//
//  Created by Ben on 2022/3/31.
//

import UIKit
import SwiftUI
import StoreKit
import SwiftyStoreKit
import FirebaseStorage
import WidgetKit

class PurchaseViewController: UIViewController {

    @IBOutlet weak var purchasePageTitle: UILabel!
    @IBOutlet weak var flowerImage: UIImageView!
    @IBOutlet weak var purchasePageDescription: UILabel!
    
    var purchaseTitle = ""
    var purchaseDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if purchaseTitle != ""
        {
            purchasePageTitle.text = purchaseTitle
            purchasePageDescription.text = purchaseDescription
        }
        
    }
    
    @IBAction func purchaseTapped(_ sender: Any) {
        showiAPScreen()
    }
    @IBAction func couponTapped(_ sender: Any) {
        let paymentQueue = SKPaymentQueue.default()
            if #available(iOS 14.0, *) {
                paymentQueue.presentCodeRedemptionSheet()
            }
    }
    
    func showiAPScreen()
    {
        SwiftyStoreKit.purchaseProduct("monthly_purchase", quantity: 1, atomically: true) { result in
            print("purchase results \(result)")
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "isPaidUser")
                global_paid_user = true
                self.getColorImageHandler()
                
                //Update Parent VC
                self.dismiss(animated: true) {
                    self.presentingViewController?.viewWillAppear(true)
                }
                
            case .error(let error):
                
                alertViewHandler().control(title: "發生錯誤", body: "\((error as NSError).localizedDescription)", iconText: "😅")
                
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            case .deferred(purchase: let purchase):
                                            alertViewHandler().control(title: "發生錯誤", body: "發生錯誤", iconText: "😅")
                print("Unknown error. Please contact support")
            }
        }
    }
    
    func getColorImageHandler()
    {
        coloredflowerHandler().getFlowerImageURL { (name, image_url, meaning) in
            DispatchQueue.main.async { [self] in
                
                // Get a reference to the storage service using the default Firebase App
                let storage = Storage.storage()
                
                // Create a storage reference from our storage service
                let storageRef = storage.reference()
                
                print("get url \(image_url)")
                // Reference to an image file in Firebase Storage
                let reference = storageRef.child("/colored_flowers/\(image_url).png")
                
                // Placeholder image
                let placeholderImage = UIImage(named: "placeholder.jpg")
                
                
                
                
                // Load the image using SDWebImage
                self.flowerImage.sd_setImage(with: reference, placeholderImage: placeholderImage) { (image, error, cache, ref) in
                    if error != nil
                    {
                        print("unable to load new image \(error)")
                        flowerHandler().storeImage(image: UIImage(named: "flower_10_babys breath_滿天星")!, forKey: "FlowerImage", withStorageType: .userDefaults)
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set("滿天星", forKey: "FlowerName")
                        //更新Widget
                        if #available(iOS 14.0, *) {
                            WidgetCenter.shared.reloadAllTimelines()
                        } else {
                            // Fallback on earlier versions
                        }
                    }else
                    {
                        
                        print("Paid Plan updated - Get Color Image")
                        
                        flowerHandler().storeImage(image: image!, forKey: "FlowerImage", withStorageType: .userDefaults)
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(name, forKey: "FlowerName")
                        UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(meaning, forKey: "FlowerMeaning")
                        //更新Widget
                        if #available(iOS 14.0, *) {
                            WidgetCenter.shared.reloadAllTimelines()
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                
                alertViewHandler().control(title: "購買成功", body: "開始使用完整版的植語錄吧！", iconText: "🍻")
            }
        }
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func restoreSubscription(_ sender: Any) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                alertViewHandler().control(title: "恢復購買失敗", body: "如有問題請和開發團隊聯絡", iconText: "🍻")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                global_paid_user = true
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "isPaidUser")
                alertViewHandler().control(title: "恢復購買成功", body: "可以繼續使用完整版植語錄囉！", iconText: "🍻")
            }
            else {
                print("Nothing to Restore")
                alertViewHandler().control(title: "恢復購買失敗", body: "如有問題請和開發團隊聯絡", iconText: "🍻")
            }
        }
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
