//
//  DashboardViewController+SwipeHandling.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 5.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import FBAudienceNetwork
import GoogleMobileAds

extension DashboardViewController {
    
    private func showAdd() {
        guard ControlSettings.shouldShowAddMobBanner else { return }
        
        if ControlSettings.facebookAds {
            initializeFacebookAds()
        } else if ControlSettings.googleAds {
            showGoogleAdd()
        }
    }
    
    internal func handleProgressWithSwipe(with progress: Int) {
        
        if progress % 3 == 0 {
            showAdd(); return
        }
        
        if progress % 7 == 0 {
            if appInstance.userProfileSettings?.balance == 0.0 {
                goToCreditPage()
            } else {
                showAdd()
            }
            return
        }
        
        if progress % 10 == 0 {
            if (appInstance.userProfileSettings?.isProUser ?? false) == false {
                goToUpgradeAccount()
            } else {
                showAdd()
            }
            return
        }
        
    }
    
    private func goToCreditPage() {
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    private func goToUpgradeAccount() {
        let vc = R.storyboard.credit.upgradeAccountVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
}


extension DashboardViewController: MoveToPayScreenDelegate {
    func moveToAuthorizeNetPayScreen(status: Bool, payingInfo: PayingInformation) {
        let viewController = PayVC.instantiate(fromStoryboardNamed: .credit)
        viewController.payInfo = payingInfo
        viewController.isAuthorizeNet = true
        self.navigationController?
            .pushViewController(viewController, animated: true)
    }
    
    func moveToPayScreen(status: Bool, payingInfo: PayingInformation) {
        if status {
            let viewController = PayVC.instantiate(fromStoryboardNamed: .credit)
            viewController.payInfo = payingInfo
            self.navigationController?
                .pushViewController(viewController, animated: true)
        } else {
            let viewController = BankTransferVC.instantiate(fromStoryboardNamed: .credit)
            viewController.payInfo = payingInfo
            self.navigationController?
                .pushViewController(viewController, animated: true)
        }
    }
    
}


// MARK: - Google Ads

extension DashboardViewController: GADFullScreenContentDelegate {
    
    internal func createGoogleAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: ControlSettings.googleInterstitialAdsUnitId,
                               request: request, completionHandler: { [self] ad, error in
            if let error = error {
                Logger.error(error); return
            }
            googleInterstitial = ad
            googleInterstitial?.fullScreenContentDelegate = self
        })
    }
    
    private func showGoogleAdd() {
        if googleInterstitial != nil {
            googleInterstitial?.present(fromRootViewController: self)
        } else {
            Logger.error("getting google add")
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Logger.error("Ad did fail to present full screen content.")
        createGoogleAds()
    }
    
    /// Tells the delegate that the ad presented full screen content.
//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        Logger.debug("Ad did present full screen content.")
//        
//    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Logger.debug("Ad did dismiss full screen content.")
        createGoogleAds()
    }
    
}

// MARK: - Facebook Ads
extension DashboardViewController: FBInterstitialAdDelegate  {
    
    internal func initializeFacebookAds() {
        let interstitialAd = FBInterstitialAd(
//            placementID: ControlSettings.addsOfFacebookPlacementID
            placementID: "YOUR_PLACEMENT_ID"
        ) // "YOUR_PLACEMENT_ID" for testing
        
        interstitialAd.delegate = self
        interstitialAd.load()
        self.facebookInterstitial = interstitialAd
    }
    
    internal func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
      guard interstitialAd.isAdValid else {
        return
      }
      print("Ad is loaded and ready to be displayed")
      interstitialAd.show(fromRootViewController: self)
    }
    
    func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        Logger.error("Interstitial ad failed to load with error \(error.localizedDescription)")
    }
}
