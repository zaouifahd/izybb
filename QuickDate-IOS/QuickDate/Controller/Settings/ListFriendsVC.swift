//
//  ListFriendsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class ListFriendsVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noFavLabel: UILabel!
    @IBOutlet weak var friendsLabel: UILabel!
    @IBOutlet weak var noFavImage: UIImageView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    var mediaFiles = [String]()
    var FriendList: [[String:Any]] = []
    var interstitial: GADInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.listFiend()
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
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
            if interstitialAd != nil && interstitialAd.isAdValid {
                // You can now display the full screen ad using this code:
                interstitialAd.show(fromRootViewController: self)
            }
    }
    
    private func setupUI(){
        self.noFavImage.tintColor = UIColor().hexStringToUIColor(hex: "FF007F")
        self.friendsLabel.text = NSLocalizedString("Friends", comment: "Friends")
        self.noFavLabel.text = NSLocalizedString("You have No Friends", comment: "You have No Friends")
        
        
        let XIB = UINib(nibName: "ListFriendCollectionItem", bundle: nil)
        self.collectionView.register(XIB, forCellWithReuseIdentifier: "ListFriendCollectionItem")
        
        if ControlSettings.shouldShowAddMobBanner{
            if ControlSettings.googleAds {
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
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
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
    
    private func listFiend(){
        self.handleActivityIndicator(to: .start)
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                FriendManager.instance.getListFriends(AccessToken: accessToken, limit: 20, offset: 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            
                            self.dismissProgressDialog {
                                self.FriendList = success?.data ?? []
                                if self.FriendList.isEmpty{
                                    self.noFavImage.isHidden = false
                                    self.noFavLabel.isHidden = false
                                }else{
                                    self.noFavImage.isHidden = true
                                    self.noFavLabel.isHidden = true
                                    self.collectionView.reloadData()
                                    
                                }
                                self.handleActivityIndicator(to: .stop)
                                Logger.debug("userList = \(success?.message ?? "")")
                            }
                        })
                        
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.handleActivityIndicator(to: .stop)
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.handleActivityIndicator(to: .stop)
                            }
                        })
                    }
                }
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.handleActivityIndicator(to: .stop)
        }
    }
    
    private func handleActivityIndicator(to process: Process) {
        self.activityIndicator.isHidden = process == .stop
        switch process {
        case .start: self.activityIndicator.startAnimating()
        case .stop:  self.activityIndicator.stopAnimating()
        }
    }
    
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListFriendCollectionItem", for: indexPath) as! ListFriendCollectionItem
        let object = self.FriendList[indexPath.row]
        cell.vc = self
        cell.bind(object)
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 40)/2
        let height = (collectionView.frame.size.height - 24)/2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
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
          let vc = R.storyboard.main.showUserDetailsViewController()
    self.mediaFiles.removeAll()
    let userObject = FriendList[indexPath.row]
    let mediaFiles = userObject["mediafiles"] as? [[String:Any]]
    for item in mediaFiles ?? []{
        let full = item["full"] as? String
        self.mediaFiles.append(full ?? "")
    }
        
    vc?.mediaFiles = self.mediaFiles ?? []
          vc?.object = userObject
    vc?.fromProf = true
          self.navigationController?.pushViewController(vc!, animated: true)
      }
}
