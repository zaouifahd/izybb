//
//  FavoriteVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class FavoriteVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
//    @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var noImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var favoriteUser = [[String:Any]]()
    var mediaFiles = [String]()
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    private func setupUI(){
        self.noImage.tintColor = UIColor().hexStringToUIColor(hex: "FF007F")
        
        let XIB = UINib(nibName: "FavoriteCollectionItem", bundle: nil)
        self.collectionView.register(XIB, forCellWithReuseIdentifier: "FavoriteCollectionItem")
        
        self.favoriteLabel.text = NSLocalizedString("Favorite", comment: "Favorite")
        self.noLabel.text = NSLocalizedString("There is no Favourite User", comment: "There is no Favourite User")
        if ControlSettings.shouldShowAddMobBanner{
            
            if ControlSettings.googleAds{
                
                let request = GADRequest()
                GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                                       request: request,
                                       completionHandler: { (ad, error) in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    self.interstitial = ad
                }
                )
            }
        }
    }
    func CreateAd() -> GADInterstitialAd {
        
        GADInterstitialAd.load(withAdUnitID:ControlSettings.googleInterstitialAdsUnitId,
                               request: GADRequest(),
                               completionHandler: { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
        }
        )
        return  self.interstitial
        
    }
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
            self.favoriteUser.removeAll()
            let accessToken = AppInstance.shared.accessToken ?? ""
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            Async.background({
                FavoriteManager.instance.fetchFavorite(AccessToken: accessToken, limit: 50, offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.data ?? [])")
                                if (success?.data!.isEmpty)!{
                                    self.noImage.isHidden = false
                                    self.noLabel.isHidden = false
                                }else{
                                    self.favoriteUser = success?.data ?? []
                                    self.collectionView.reloadData()
                                    self.noImage.isHidden = true
                                    self.noLabel.isHidden = true
                                    self.activityIndicator.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                            }
                            
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                            }
                        })
                    }
                }
            })
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}
extension FavoriteVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoriteUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.favoriteCollectionItem.identifier, for: indexPath) as? FavoriteCollectionItem
        let  object = self.favoriteUser[indexPath.row]
        cell!.vc = self
        cell?.bind(object, index: indexPath.row)
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppInstance.shared.addCount == ControlSettings.interestialCount {
            if ControlSettings.facebookAds {
                if let ad = interstitial {
                    interstitialAd1 = FBInterstitialAd(placementID: ControlSettings.addsOfFacebookPlacementID)
                    interstitialAd1?.delegate = self
                    interstitialAd1?.load()
                } else {
                    print("Ad wasn't ready")
                }
            }else if ControlSettings.googleAds{
                interstitial.present(fromRootViewController: self)
                interstitial = CreateAd()
                AppInstance.shared.addCount = 0
            }
        }
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1
        self.mediaFiles.removeAll()
        let userObject = favoriteUser[indexPath.row]
        let mediaFiles = userObject["mediafiles"] as? [[String:Any]]
        for item in mediaFiles ?? []{
            let full = item["full"] as? String
            self.mediaFiles.append(full ?? "")
        }
        let vc = R.storyboard.main.showUserDetailsViewController()
        
        vc?.mediaFiles = self.mediaFiles ?? []
        vc?.object = userObject
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
