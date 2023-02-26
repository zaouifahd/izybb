//
//  BlockUserVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class BlockUserVC: BaseViewController, FBInterstitialAdDelegate {
    
    var interstitialAd1: FBInterstitialAd?
    
    @IBOutlet weak var blockUserLabel: UILabel!
    @IBOutlet weak var noBlockLabel: UILabel!
    @IBOutlet weak var noBlockImage: UIImageView!
    @IBOutlet var blockedUsersTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    //    var blockUsersArray = [[String:Any]]()
    private var blockUsersArray: [Relation] = []
    
    var interstitial: GADInterstitialAd!
    
    // MARK: - Properties
    
    private let appInstance: AppInstance = .shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        blockedUsersTableView.delegate = self
        blockedUsersTableView.dataSource = self
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        print("Ad is loaded and ready to be displayed")
        
        if interstitialAd != nil && interstitialAd.isAdValid {
            // You can now display the full screen ad using this code:
            interstitialAd.show(fromRootViewController: self)
        }
    }
    
    
    //MARK:- Methods
    private func setupUI(){
        noBlockImage.tintColor = UIColor.Main_StartColor
        self.blockUserLabel.text = NSLocalizedString("BLocked Users", comment: "BLocked Users")
        self.noBlockLabel.text = NSLocalizedString("There is no Blocked User", comment: "There is no Blocked User")
        //        self.blockUsersArray = AppInstance.shared.userProfile["blocks"] as? [[String:Any]] ?? []
        self.blockUsersArray = appInstance.userProfileSettings?.blocks ?? []
        if (self.blockUsersArray.isEmpty){
            self.noBlockImage.isHidden = false
            self.noBlockLabel.isHidden = false
        }else{
            self.noBlockImage.isHidden = true
            self.noBlockLabel.isHidden = true
        }
//        blockedUsersTableView.register(R.nib.blockUserTableItem(), forCellReuseIdentifier: R.reuseIdentifier.blockUserTableItem.identifier)
        
        
        let XIB = UINib(nibName: "BlockUserTableItem", bundle: nil)
        self.blockedUsersTableView.register(XIB, forCellReuseIdentifier: R.reuseIdentifier.blockUserTableItem.identifier)
        
        if ControlSettings.shouldShowAddMobBanner {
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
                })
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
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    private func unBlockAlert(userID:String,index:Int){
        
        let alert = UIAlertController(title: "", message: "Unblock", preferredStyle: .actionSheet)
        let unBlock = UIAlertAction(title: "Unblock", style: .default) { (action) in
            self.unBlockUser(userId: userID, index: index)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(unBlock)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    private func unBlockUser(userId:String,index:Int){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(with: "Loading...")
            
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(userId ?? "") ?? 0
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.blockUsersArray.remove(at: index)
                                self.blockedUsersTableView.reloadData()
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                let errorText = sessionError?.errors?["error_text"] as? String
                                self.view.makeToast(errorText ?? "")
                                Logger.error("sessionError = \(errorText ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
}

extension BlockUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.blockUsersArray.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blockUserTableItem.identifier, for: indexPath) as! BlockUserTableItem
        let object = self.blockUsersArray[indexPath.row]
        cell.configView()
        cell.bind(object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        //        AppInstance.shared.addCount = AppInstance.shared.addCount! + 1
        //        let object = AppInstance.shared.userProfile["blocks"] as? [[String:Any]]
        //        let userBlockData = object?[indexPath.row]["data"] as? [String:Any]
        //        let id = userBlockData?["id"] as? String
        
        appInstance.addCount = appInstance.addCount + 1
        let object = appInstance.userProfileSettings?.blocks[indexPath.row]
        let blockedUserID = object?.userIdOfRelatedUser ?? 0
        self.unBlockAlert(userID: String(blockedUserID), index: indexPath.row)
    }
}

