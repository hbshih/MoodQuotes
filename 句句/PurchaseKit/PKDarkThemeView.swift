//
//  Created by Apps4World on 8/17/20.
//  Copyright © 2020 Apps4World. All rights reserved.
//

import SwiftUI
import PurchaseKit

struct PKDarkThemeView: View {
    
    var title: String
    var subtitle: String
    var features: [String]
    var productIds: [String]
    @State var completion: PKCompletionBlock?
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Privacy Policy, Terms & Conditions URLs
    // NOTE: You must provide these 2 URLs
    private let privacyPolicyURL: URL = URL(string: "https://google.com/")!
    private let termsAndConditionsURL: URL = URL(string: "https://google.com/")!
    
    /// If you don't have the URLs mentioned above, you can hide the buttons by setting this to `true`
    private let hidePrivacyPolicyTermsButtons: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        VStack {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    HeaderSectionView
                    
                    VStack {
                        FeaturesListView
                        ProductsListView
                    }.padding(.top, 40).padding(.bottom, 20)
                    
                    RestorePurchases
                    PrivacyPolicyTermsSection
                    DisclaimerTextView
                }
                
                CloseButtonView
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.75), .black]), startPoint: .top, endPoint: .bottom)).edgesIgnoringSafeArea(.all)
    }
    
    /// Header view
    private var HeaderSectionView: some View {
        VStack {
            /// Image for the header
            Image("dark-header").resizable().aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: 350).clipped()
            /// Title & Subtitle
            VStack {
                Text(title).font(.largeTitle).bold()
                Text(subtitle).font(.headline)
            }.foregroundColor(.white).padding()
        }
    }
    
    /// Features scroll list view
    private var FeaturesListView: some View {
        VStack {
            ForEach(0..<features.count) { index in
                HStack {
                    Image(systemName: "checkmark.circle").resizable()
                        .frame(width: 25, height: 25).foregroundColor(.white)
                    Text(self.features[index]).font(.system(size: 22)).foregroundColor(.white)
                    Spacer()
                }
            }.padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 45)
        }
    }
    
    /// List of products
    private var ProductsListView: some View {
        VStack(spacing: 10) {
            ForEach(0..<productIds.count) { index in
                Button(action: {
                    PKManager.purchaseProduct(identifier: self.productIds[index], completion: self.completion)
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 28.5).foregroundColor(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))).frame(height: 57)
                        VStack {
                            Text(PKManager.formattedProductTitle(identifier: self.productIds[index])).foregroundColor(.white).bold()
                            if !PKManager.introductoryPrice(identifier: self.productIds[index]).isEmpty {
                                Text(PKManager.introductoryPrice(identifier: self.productIds[index]))
                                    .font(.system(size: 13)).fontWeight(.light).foregroundColor(.white)
                            }
                        }
                    }
                })
            }
        }.padding(.leading, 30).padding(.trailing, 30).padding(.top, 10)
    }
    
    /// Close button on the top header
    private var CloseButtonView: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    PKManager.dismissInAppPurchaseScreen()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable().accentColor(.black).frame(width: 32, height: 32)
                })
            }
            Spacer()
        }.padding(20).edgesIgnoringSafeArea(.top)
    }
    
    /// Restore purchases button
    private var RestorePurchases: some View {
        Button(action: {
            PKManager.restorePurchases { (error, status, id) in
                self.presentationMode.wrappedValue.dismiss()
                self.completion?((error, status, id))
            }
        }, label: {
            Text("Restore Purchases")
        }).foregroundColor(.white)
    }
    
    /// Privacy Policy, Terms & Conditions section
    private var PrivacyPolicyTermsSection: some View {
        HStack(spacing: 20) {
            if hidePrivacyPolicyTermsButtons == false {
                Button(action: {
                    UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Privacy Policy")
                })
                Button(action: {
                    UIApplication.shared.open(termsAndConditionsURL, options: [:], completionHandler: nil)
                }, label: {
                    Text("Terms & Conditions")
                })
            }
        }.font(.system(size: 10)).foregroundColor(.gray).padding()
    }
    
    /// Disclaimer text view at the bottom
    private var DisclaimerTextView: some View {
        VStack {
            Text(PKManager.disclaimer).font(.system(size: 12))
                .multilineTextAlignment(.center)
                .padding(.leading, 30).padding(.trailing, 30)
            Spacer(minLength: 50)
        }.foregroundColor(.white)
    }
}
