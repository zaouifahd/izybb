//
//  ShowUserDetailsTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import FittedSheets
import QuickDateSDK

protocol BlogUserDelegate: AnyObject {
    func dislikeUser()
}

class ShowUserDetailsTableItem: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarimage: UIImageView!
    @IBOutlet weak var giftView: UIView!
    @IBOutlet weak var addFriendView: UIView!
    @IBOutlet weak var favoriteView: UIView!
    @IBOutlet var emptyButtonList: [UIButton]!
    
    // MARK: - Properties
    private var isFavorite: Bool = false
    
    var otherUser: OtherUser? {
        didSet {
            guard let otherUser = otherUser else {
                Logger.error("getting other user"); return
            }
            self.nameLabel.text = otherUser.userDetails.fullName
            let url = URL(string: otherUser.userDetails.avatar)
            self.avatarimage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
            
            handleFriendRequestAtFirstLoading(with: otherUser.userDetails.id)
            
            let image: UIImage? = otherUser.userDetails.isFavorite ?? false ? .stareFill : .starEmpty
            self.starImageView.image = image
            isFavorite = otherUser.userDetails.isFavorite ?? false
        }
    }
    // Property Injections
    private let networkManager: NetworkManager = .shared
    private let accessToken = AppInstance.shared.accessToken ?? ""
    
    
    weak var blogDelegate: BlogUserDelegate?
    var mediaFiles = [String]()
    var controller: ShowUserDetailsViewController?
    var baseVC: BaseViewController?
    
    var object = [String:Any]()
    var isNotification: Bool? = false
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        emptyButtonList.forEach {$0.setTitle("", for: .normal)}
    }
    // MARK: - Services
    
    private func handleFriendRequestAtFirstLoading(with userId: Int) {
        let params: APIParameters = [
            API.PARAMS.user_id: "\(userId)",
            API.PARAMS.access_token: accessToken,
            API.PARAMS.fetch: "data,media"
        ]
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.PROFILE_API,
                method: .post,
                parameters: params,
                successCode: .code) { response in
                    switch response {
                    case .failure(let error): Logger.error(error)
                        
                    case .success(let json):
                        guard let data = json["data"] as? JSON else {
                            Logger.error("getting data"); return
                        }
                        let userProfile = UserProfile(dict: data)
                        self.handleAddFriendButton(isFriend: userProfile.isFriend,
                                                   isRequest: userProfile.isFriendRequest)
                        self.handleVerification(with: userProfile.isVerified)
                    }
                }
        })
    }
    
    private func handleVerification(with isVerified: Bool) {
        Async.main({
            self.verifiedIcon.isHidden = !isVerified
        })
    }
    
    private func handleAddFriendButton(isFriend: Bool, isRequest: Bool) {
        let image: UIImage? = isFriend || isRequest ? .friendClock : .friendPlus
        Async.main({
            self.requestImage.image = image
        })
        
    }
    
    // MARK: Block
    private func blockUser(with userId: Int) {
        guard isConnectedToNetwork() else { return }
        
        let params: APIParameters = [API.PARAMS.access_token: accessToken,
                                      API.PARAMS.block_userid: "\(userId)"]
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.BLOCK_API,
                method: .post,
                parameters: params,
                successCode: .code) { (response: Result<JSON, Error>) in
                    switch response {
                    case .failure(let error):
                        self.baseVC?.dismissProgressDialog {
                            Async.main({
                                self.controller?.view.makeToast(error.localizedDescription)
                                Logger.error("error = \(error.localizedDescription )")
                            })
                        }
                    case .success(let json):
                        let success = MainNetworkModel(dict: json, successCode: .code)
                        self.baseVC?.dismissProgressDialog {
                            Async.main({
                                Logger.debug("userList = \(success.message)")
                                self.blogDelegate?.dislikeUser()
                                self.controller?.view.makeToast(success.message)
                                self.controller?.navigationController?.popViewController(animated: true)
                            })
                        }
                        
                    }
                }
        })
    }
    
    // MARK: Report
    private func reportUser(with userId: Int) {
        guard isConnectedToNetwork() else { return }
        
        let params: APIParameters = [API.PARAMS.access_token: accessToken,
                                      API.PARAMS.report_userid: "\(userId)"]
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.REPORT_API,
                method: .post,
                parameters: params,
                successCode: .code) { (response: Result<JSON, Error>) in
                    switch response {
                    case .failure(let error):
                        self.baseVC?.dismissProgressDialog {
                            Async.main({
                                self.controller?.view.makeToast(error.localizedDescription)
                                Logger.error("error = \(error.localizedDescription )")
                            })
                        }
                    case .success(let json):
                        let success = MainNetworkModel(dict: json, successCode: .code)
                        self.baseVC?.dismissProgressDialog {
                            Async.main({
                                Logger.debug("userList = \(success.message)")
                                self.controller?.view.makeToast(success.message)
                                self.controller?.navigationController?.popViewController(animated: true)
                            })
                        }
                        
                    }
                }
        })
    }
    // MARK: AddRequest
    private func addRequest(uid: String) {
        guard isConnectedToNetwork() else { return }
        
        let params: APIParameters = [API.PARAMS.access_token: accessToken,
                                      API.PARAMS.uid: uid]
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.FRIEND_REQUEST_CONSTANT_METHODS.ADD_FRIEND_API,
                method: .post,
                parameters: params,
                successCode: .status) { (response: Result<JSON, Error>) in
                    switch response {
                    case .failure(let error):
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                self.controller?.view.makeToast(error.localizedDescription)
                                Logger.error("error = \(error.localizedDescription )")
                            }
                        })
                    case .success(let json):
                        let success = MainNetworkModel(dict: json, successCode: .code)
                        let isDeleted = success.message == "Request deleted"
                        let message = isDeleted
                        ? "The Friendship has been canceled" : "The request has been sent, wait for approval"
                        let image: UIImage? = isDeleted ? .friendPlus : .friendClock
                        
                        Async.main({
                            self.baseVC?.dismissProgressDialog {
                                Logger.debug("userList = \(success.message)")
                                self.requestImage.image = image
                                self.controller?.view.makeToast(message)
                            }
                        })
                    }
                }
        })
        
    }
    
    // MARK: Favorite
    private func favorite(uid: Int, isAdded: Bool) {
        guard isConnectedToNetwork() else { return }
        
        let params: APIParameters = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.uid: "\(uid)"
        ]
        let urlString: String = {
            switch isAdded {
            case true:  return API.FAVORITE_CONSTANT_METHODS.ADD_FAVORITE_API
            case false: return API.FAVORITE_CONSTANT_METHODS.DELETE_FAVORITE_API
            }
        }()
    
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: urlString, method: .post, parameters: params,
                successCode: .status) { [self] (response: Result<JSON, Error>) in
                switch response {
                case .failure(let error):
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.controller?.view.makeToast(error.localizedDescription)
                            Logger.error("error = \(error.localizedDescription)")
                        }
                    })
                case .success(_):
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.isFavorite = !self.isFavorite
                            let image: UIImage? = isAdded ? .stareFill : .starEmpty
                            self.starImageView.image = image
                        }
                    })
                }
            }
        })
    }
    
    // MARK: - Send Gift
    
    private func sendGift(giftID: Int) {
        guard let userId = otherUser?.userDetails.id else {
            Logger.error("getting userId"); return
        }
//        let giftHashId = Int(arc4random_uniform(UInt32(100000)))
        
        let params: APIParameters = [
            API.PARAMS.access_token: accessToken,
            API.PARAMS.to_userid: "\(userId)",
            API.PARAMS.gift_id: "\(giftID)"
        ]
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.SEND_GIFT_API,
                method: .post,
                parameters: params,
                successCode: .code) { (response: Result<JSON, Error>) in
                    switch response {
                    case .failure(let error):
                        self.baseVC?.dismissProgressDialog {
                            Async.main({
                                self.controller?.view.makeToast(error.localizedDescription)
                                Logger.error("error = \(error.localizedDescription )")
                            })
                        }
                    case .success(let json):
                        let model = MainNetworkModel(dict: json, successCode: .code)
                        self.baseVC?.dismissProgressDialog {
                            Logger.debug("userList = \(model.message)")
                        }
                        
                    }
                }
        })
    }
    
    // MARK: Share
    private func shareUser(with userDetails: UserDetailFeatures) {
        let urlString = "\(API.justURL)/@\(userDetails.userName)"
        guard let objectsToShare = URL(string: urlString) else {
            Logger.error("Getting objectsToShare"); return
        }
        let someText: String = "Check \(userDetails.fullName) profile on QuickDate!"
        let sharedObjects: [AnyObject] = [objectsToShare as AnyObject, someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = moreBtn
        activityViewController.popoverPresentationController?.sourceRect = moreBtn.bounds
        self.controller?.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    private func isConnectedToNetwork() -> Bool {
        guard Connectivity.isConnectedToNetwork() else {
            Logger.error("internetError = \(InterNetError)")
            Async.main({
                self.controller?.view.makeToast(InterNetError)
            })
            return false
        }
        return true
    }
    
    // MARK: - Actions
    @IBAction func friendButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        self.addRequest(uid: String(otherUser?.userDetails.id ?? 0))
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let isAdded = isFavorite ? false : true
        self.favorite(uid: otherUser?.userDetails.id ?? 0, isAdded: isAdded)
    }
    
    @IBAction func giftButtonPressed(_ sender: UIButton) {
        Logger.debug("pressed")
        let viewController = StickersViewController.instantiate(fromStoryboardNamed: .chat)
        viewController.giftDelegate = self
        viewController.checkStatus = true
        let sheetController = SheetViewController(controller: viewController)
        sheetController.hasBlurBackground = true
        self.controller?.present(sheetController, animated: false, completion: nil)
    }
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        guard let userDetails = otherUser?.userDetails else {
            Logger.error("getting userId"); return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let block = UIAlertAction(title: "Block".localized, style: .destructive) { (_) in
            self.blockUser(with: userDetails.id)
        }
        let report = UIAlertAction(title: "Report".localized, style: .default) { (_) in
            self.reportUser(with: userDetails.id)
        }
        let share = UIAlertAction(title: "Share".localized, style: .default) { (_) in
            self.shareUser(with: userDetails)
        }
        
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(share)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - GiftDelegate

extension ShowUserDetailsTableItem: GiftDelegate {
    func selectGift(with giftId: Int) {
        sendGift(giftID: giftId)
    }
}

extension ShowUserDetailsTableItem: NibReusable {}
