//
//  Copyright (C) 2016 Google, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import GoogleMobileAds
import UIKit

class RewardedAdViewController: UIViewController, GADFullScreenContentDelegate {
  /// The rewarded video ad.
  var rewardedAd: GADRewardedAd?
    
  /// In-game text that indicates current counter value or game over state.
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var noAdsButton: UIButton!
    @IBOutlet weak var explationMessage: UILabel!
    @IBOutlet weak var nativeAdPlaceholder: UIView!
    var played = false
    
    var adLoader: GADAdLoader!
    /// The height constraint applied to the ad view, where necessary.
    var heightConstraint: NSLayoutConstraint?

  /// Button to restart game.
  @IBOutlet weak var playAgainButton: UIButton!
    
    /// The native ad view that is being presented.
    var nativeAdView: GADNativeAdView!

  override func viewDidLoad() {
    super.viewDidLoad()
      
      //Native ad
      //versionLabel.text = GADMobileAds.sharedInstance().sdkVersion
      guard
        let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
        let adView = nibObjects.first as? GADNativeAdView
      else {
        assert(false, "Could not load nib file for adView")
      }
      setAdView(adView)
      
      // Reward ad
      GADRewardedAd.load(
        withAdUnitID: "ca-app-pub-5153344112585383/5827472367", request: GADRequest()
      ) { (ad, error) in
        if let error = error {
          print("Rewarded ad failed to load with error: \(error.localizedDescription)")
          return
        }
        print("Loading Succeeded")
        self.rewardedAd = ad
        self.rewardedAd?.fullScreenContentDelegate = self
      }
   
      explationMessage.alpha = 0.0
      button.alpha = 0.0
      buttonView.alpha  = 0.0
      noAdsButton.alpha  = 0.0
      
      
  }
    
    func setAdView(_ view: GADNativeAdView) {
      // Remove the previous ad view.
      nativeAdView = view
      nativeAdPlaceholder.addSubview(nativeAdView)
      nativeAdView.translatesAutoresizingMaskIntoConstraints = false

      // Layout constraints for positioning the native ad view to stretch the entire width and height
      // of the nativeAdPlaceholder.
      let viewDictionary = ["_nativeAdView": nativeAdView!]
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "H:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "V:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
    }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let trialWords = ["廣告即將播放\n這個廣告讓植語錄維持免費", "看個廣告讓植語錄維持免費", "感謝接下來的廣告\n讓植語錄多活三天","抱歉\n要讓你看個廣告\n植語錄才能維持免費。","即將播放廣告\n這樣植語錄才能繼續免費下去"]
        // get random elements
        let randomTrialName = trialWords.randomElement()!
        
        if !played
        {
            UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveLinear) {
                // imageView.image = UIImage(named: "icon_gesture")
                self.explationMessage.text = "廣告即將播放\n這個廣告讓植語錄維持免費"
                self.explationMessage.alpha = 1.0
            } completion: { (true) in
                UIView.animate(withDuration: 0.5, delay: 2.0) {
                    self.explationMessage.alpha = 0.0
                } completion: { [self] (true) in
                    self.played = true
                    
                   // refreshAdButton.isEnabled = false
                   // videoStatusLabel.text = ""
                    adLoader = GADAdLoader(
                      adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
                      adTypes: [.native], options: nil)
                    adLoader.delegate = self
                    adLoader.load(GADRequest())
                    
                    /*
                    if let ad = rewardedAd {
                        ad.present(fromRootViewController: self) {
                            let reward = ad.adReward
                            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                            //self.earnCoins(NSInteger(truncating: reward.amount))
                            // TODO: Reward the user.
                            self.explationMessage.alpha = 1.0
                            self.explationMessage.text = "語錄準備好囉！"
                            self.button.alpha = 1.0
                            self.buttonView.alpha = 1.0
                            self.noAdsButton.alpha = 1.0
                        }
                    } else {
                        print("reward not ready")
                        //closeButton.isHidden = false
                        self.explationMessage.alpha = 1.0
                        self.explationMessage.text = "語錄準備好囉！"
                        button.alpha = 1.0
                        buttonView.alpha = 1.0
                        noAdsButton.alpha = 1.0
                    }
                     */
                }
                
            }
            
        }
        
    }
    
    

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    



  @IBAction func playAgain(_ sender: AnyObject) {

  }

  // MARK: GADFullScreenContentDelegate

  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Rewarded ad will be presented.")
  }

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("Rewarded ad dismissed.")
  }

  func ad(
    _ ad: GADFullScreenPresentingAd,
    didFailToPresentFullScreenContentWithError error: Error
  ) {
    print("Rewarded ad failed to present with error: \(error.localizedDescription).")
  }

  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.removeObserver(
      self,
      name: UIApplication.didBecomeActiveNotification, object: nil)
  }
}

extension RewardedAdViewController: GADVideoControllerDelegate {

  func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    //ideoStatusLabel.text = "Video playback has ended."
      print("finish playing video")
  }
}

extension RewardedAdViewController: GADAdLoaderDelegate {
  func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    print("\(adLoader) failed with error: \(error.localizedDescription)")
    //refreshAdButton.isEnabled = true
  }
}

extension RewardedAdViewController: GADNativeAdLoaderDelegate {

  func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
//    refreshAdButton.isEnabled = true

    // Set ourselves as the native ad delegate to be notified of native ad events.
    nativeAd.delegate = self

    // Deactivate the height constraint that was set when the previous video ad loaded.
    heightConstraint?.isActive = false

    // Populate the native ad view with the native ad assets.
    // The headline and mediaContent are guaranteed to be present in every native ad.
    (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
    nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

    // Some native ads will include a video asset, while others do not. Apps can use the
    // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
    // UI accordingly.
    let mediaContent = nativeAd.mediaContent
    if mediaContent.hasVideoContent {
      // By acting as the delegate to the GADVideoController, this ViewController receives messages
      // about events in the video lifecycle.
      mediaContent.videoController.delegate = self
     // videoStatusLabel.text = "Ad contains a video asset."
    } else {
     // videoStatusLabel.text = "Ad does not contain a video."
    }

    // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
    // ratio of the media it displays.
    if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
      heightConstraint = NSLayoutConstraint(
        item: mediaView,
        attribute: .height,
        relatedBy: .equal,
        toItem: mediaView,
        attribute: .width,
        multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
        constant: 0)
      heightConstraint?.isActive = true
    }

    // These assets are not guaranteed to be present. Check that they are before
    // showing or hiding them.
    (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
    nativeAdView.bodyView?.isHidden = nativeAd.body == nil

    (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
    nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

    (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
    nativeAdView.iconView?.isHidden = nativeAd.icon == nil

    (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
    nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

    (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
    nativeAdView.storeView?.isHidden = nativeAd.store == nil

    (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
    nativeAdView.priceView?.isHidden = nativeAd.price == nil

    (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
    nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

    // In order for the SDK to process touch events properly, user interaction should be disabled.
    nativeAdView.callToActionView?.isUserInteractionEnabled = false

    // Associate the native ad view with the native ad object. This is
    // required to make the ad clickable.
    // Note: this should always be done after populating the ad views.
    nativeAdView.nativeAd = nativeAd

  }
}

// MARK: - GADNativeAdDelegate implementation
extension RewardedAdViewController: GADNativeAdDelegate {

  func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }

  func nativeAdWillLeaveApplication(_ nativeAd: GADNativeAd) {
    print("\(#function) called")
  }
}
