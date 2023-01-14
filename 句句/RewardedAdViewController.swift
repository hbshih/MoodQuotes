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
    var played = false

  /// Button to restart game.
  @IBOutlet weak var playAgainButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
      
      GADRewardedAd.load(
        withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest()
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
