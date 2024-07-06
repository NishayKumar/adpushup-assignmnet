//
//  ViewController.swift
//  adpushup
//
//  Created by Nishay Kumar on 06/07/24.
//
import GoogleMobileAds
import UIKit

class ViewController: UIViewController {
    
    private var rewardedAdHelper: RewardedAdHelper?
    
    
    @IBAction func adButton(_ sender: UIButton) {
        rewardedAdHelper?.show(viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardedAdHelper = RewardedAdHelper()
        rewardedAdHelper?.loadRewardedAd()
    }
}

class RewardedAdHelper: NSObject, GADFullScreenContentDelegate {
    private var rewardedAd: GADRewardedAd?
    
    func loadRewardedAd() {
        Task {
            do {
                rewardedAd = try await GADRewardedAd.load(
                    withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: GADRequest())
                
                rewardedAd?.fullScreenContentDelegate = self
                
            } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
            }
        }
    }
    
    func show(viewController: UIViewController) {
        guard let rewardedAd = rewardedAd else {
            print("Ad wasn't ready.")
            return
        }
        
        rewardedAd.present(fromRootViewController: viewController) {
            let reward = rewardedAd.adReward
            print("\(reward.amount) \(reward.type)")
            
        }
    }
    
    // error handling
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
}
