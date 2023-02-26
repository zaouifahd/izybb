//
//  ChatVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import GoogleMobileAds
import FBAudienceNetwork
import QuickDateSDK

class ChatVC: BaseViewController, FBInterstitialAdDelegate {
    
    // MARK: - Views
    // @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var noMsgLabel: UILabel!
    @IBOutlet weak var noMsgImage: UIImageView!
    @IBOutlet var messagesTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionViewOnlineUser: UICollectionView!
    
    // MARK: - Properties
    private let appNavigator: AppNavigator = .shared
    private let networkManager: NetworkManager = .shared
    
    var messagesList: [[String:Any]] = []
    var offset: Int = 0
    var interstitial: GADInterstitialAd!
    var interstitialAd1: FBInterstitialAd?
    private let flowLayout = UICollectionViewFlowLayout()
    
    private var isPageLoaded: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        isPageLoaded = true
    }
    
    
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard isPageLoaded ?? false else { return } // Safety Check
        
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
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
        self.backView.backgroundColor = Theme.primaryEndColor.colour
        self.noMsgImage.tintColor = .Main_StartColor
        self.chatLabel.text = NSLocalizedString("Chat", comment: "Chat")
        self.noMsgLabel.text  = NSLocalizedString("There are no messages", comment: "There are no messages")
        
        self.messagesTableView.separatorStyle = .none
//        self.messagesTableView.register(R.nib.chatScreenTableItem(), forCellReuseIdentifier: R.reuseIdentifier.chatScreenTableItem.identifier)
        
        let XIB = UINib(nibName: "ChatScreenTableItem", bundle: nil)
        self.messagesTableView.register(XIB, forCellReuseIdentifier: "ChatScreenTableItem")
        
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
        collectionViewOnlineUser.delegate = self
        collectionViewOnlineUser.dataSource = self
        collectionViewOnlineUser.register(cellType: OnlineUserCollectionItem.self)
        collectionViewOnlineUser.collectionViewLayout = flowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Methods
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
            messagesList.removeAll()
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                ChatManager.instance.getConversation(AccessToken: accessToken, Limit: 20, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.data ?? [])")
                                
                                self.messagesList = success?.data ?? []
                                
                                if self.messagesList.isEmpty{
                                    self.noMsgImage.isHidden = false
                                    self.noMsgLabel.isHidden = false
                                    self.activityIndicator.isHidden = true
                                    self.collectionViewOnlineUser.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                }else{
                                    self.noMsgImage.isHidden = true
                                    self.noMsgLabel.isHidden = true
                                    self.messagesTableView.reloadData()
                                    self.collectionViewOnlineUser.reloadData()
                                    self.collectionViewOnlineUser.isHidden = false
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
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
        //        createMainViewGradientLayer(to: upperPrimaryView,
        //                                    startColor: startColor,
        //                                    endColor: endColor)
    }
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0.1))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatScreenTableItem.identifier, for: indexPath) as! ChatScreenTableItem
        //  cell.avatarImageView.circleView()
        if messagesList.count == 0{
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let object = self.messagesList[indexPath.row]
        cell.bind(object)
        return cell
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
        AppInstance.shared.addCount = AppInstance.shared.addCount + 1
        if self.messagesList.count != 0{
            Async.main({
                let object = self.messagesList[indexPath.row]
                let user = object["user"] as? [String:Any]
                let id = user?["id"] as? String
                let username = user?["username"] as? String
                let lastseen = user?["lastseen"] as? String
                let avatar = user?["avatar"] as? String
                let vc = R.storyboard.chat.chatScreenVC()
                vc?.toUserId  = id ?? ""
                vc?.usernameString = username ?? ""
                vc?.lastSeenString =  lastseen ?? ""
                vc?.profileImageString = avatar ?? ""
                self.navigationController?.pushViewController(vc!, animated: true)
            })
            
        }else{
        }
    }
}

// MARK: - DataSource

extension ChatVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as OnlineUserCollectionItem
        let object = self.messagesList[indexPath.row]
        cell.bind(object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.messagesList.count != 0{
            Async.main({
                let object = self.messagesList[indexPath.row]
                let user = object["user"] as? [String:Any]
                let id = user?["id"] as? String
                let username = user?["username"] as? String
                let lastseen = user?["lastseen"] as? String
                let avatar = user?["avatar"] as? String
                let vc = R.storyboard.chat.chatScreenVC()
                vc?.toUserId  = id ?? ""
                vc?.usernameString = username ?? ""
                vc?.lastSeenString =  lastseen ?? ""
                vc?.profileImageString = avatar ?? ""
                self.navigationController?.pushViewController(vc!, animated: true)
            })
            
        }
    }
}

// MARK: - FlowLayout
extension ChatVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 100.0)
    }
}
