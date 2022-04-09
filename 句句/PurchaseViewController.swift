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

class PurchaseViewController: UIViewController {

    @IBOutlet weak var purchasePageTitle: UILabel!
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
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                UserDefaults(suiteName: "group.BSStudio.Geegee.ios")!.set(true, forKey: "isPaidUser")
                global_paid_user = true
                
                alertViewHandler().control(title: "購買成功", body: "開始使用完整版的植語錄吧！", iconText: "🍻")
                
            case .error(let error):
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
                print("Unknown error. Please contact support")
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
