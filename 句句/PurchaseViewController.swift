//
//  PurchaseViewController.swift
//  句句
//
//  Created by Ben on 2022/3/31.
//

import UIKit
import PurchaseKit
import SwiftUI
import StoreKit

class PurchaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func purchaseTapped(_ sender: Any) {
        showiAPScreen()
    }
    
    func showiAPScreen()
    {
        PKManager.present(theme: AnyView(SubscriptionFlow), fromController: self)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private var SubscriptionFlow: some View {
        PKDarkThemeView(title: "Pro", subtitle: "unlock", features: ["remove ads"], productIds: ["monthly_purchase"], completion: { error,status,identifier in
            if status == .success || status == .restored {
                /// If the purchase was successful or restored, unlock any content, remove ads or do anything you have to do
            }
        })
    }
}
