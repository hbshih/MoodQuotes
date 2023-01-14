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

class RewardedAdActualViewController: UIViewController, GADFullScreenContentDelegate {
    @IBOutlet weak var closeButton: UIButton!
    /// The rewarded video ad.
  var rewardedAd: GADRewardedAd?
    
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

  }
    
    override func viewDidAppear(_ animated: Bool) {
        if let ad = rewardedAd {
          ad.present(fromRootViewController: self) {
            let reward = ad.adReward
            print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
            //self.earnCoins(NSInteger(truncating: reward.amount))
            // TODO: Reward the user.
          }
        } else {
            print("reward not ready")
            closeButton.isHidden = false
        }
    }
    
    
    

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
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
