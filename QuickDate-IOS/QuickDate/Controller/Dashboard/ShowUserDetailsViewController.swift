//
//  ShowUserDetailsViewController.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol UserInteractionDelegate: AnyObject {
    func performUserInteraction(with action: UserInteraction)
}

/// - Tag: ShowUserDetailsViewController
class ShowUserDetailsViewController: BaseViewController {
    
    // MARK: - View
   // @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewLike: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(cellType: ShowUserDetailsTableItem.self) // 0
            tableView.register(cellType: UserAboutCell.self) // 1
            tableView.register(cellType: UserImagesCell.self) // 2
            tableView.register(cellType: UserIntroCell.self) // 3
            tableView.register(cellType: UserLocationCell.self) // 4
            tableView.register(cellType: UserActivityCell.self) // 5, 6, 7, 8
            tableView.register(cellType: UserSocialLinkCell.self) // 9
        }
    }
    // Property Injections
    private let networkManager: NetworkManager = .shared
    var otherUser: OtherUser?
    var delegate: UserInteractionDelegate?
        
    private var randomUser: RandomUser?
//    private var notifierUser: NotifierUser?
    private var notifierUser: UserProfile?
    var shallNotify = false
    private var mediaFileList: [MediaFile] = []
    
    var object = [String:Any]()
    var mediaFiles = [String]()
    var userMedia = [String]()
    
    // FIXME: If it's not necessary then delete it
    var fromProf: Bool = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserFeatures()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Services
    private func getUserFeatures() {
        guard let otherUser = otherUser else {
            Logger.error("getting random user"); return
        }
        shallNotify = otherUser.shallNotify
    }
    
    private func performUserInteraction(with userId: String, action: UserInteraction) {
        let accessToken = AppInstance.shared.accessToken ?? ""
        var params: APIParameters = [
            API.PARAMS.access_token: accessToken
        ]
        switch action {
        case .like:    params[API.PARAMS.likes] = userId
        case .dislike: params[API.PARAMS.dislikes] = userId
        }
        guard Connectivity.isConnectedToNetwork() else {
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError); return
        }
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.ADD_LIKES_API,
                method: .post,
                                                
                parameters: params) { [weak self] (response: Result<JSON, Error>) in
                switch response {
                case .failure(let error):
                    Async.main({
                        self?.dismissProgressDialog {
                            self?.view.makeToast(error.localizedDescription)
                            Logger.error("error = \(error.localizedDescription)")
                        }
                    })
                case .success(_):
                    Async.main({
                        self?.dismissProgressDialog {
                            self?.delegate?.performUserInteraction(with: action)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }
        })
        
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chatPressed(_ sender: Any) {
        guard let userDetails = otherUser?.userDetails else {
            Logger.error("getting other user"); return
        }
        
        let vc = R.storyboard.chat.chatScreenVC()
        vc?.toUserId = "\(userDetails.id)"
        vc?.usernameString = userDetails.userName
        vc?.lastSeenString =  String(userDetails.lastseen)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func likePressed(_ sender: Any) {
        guard let userId = otherUser?.userDetails.id else {
            Logger.error("getting user id"); return
        }
//        self.addLike(with: userId)
        performUserInteraction(with: String(userId), action: .like)
      
    }
    
    @IBAction func dislikePressed(_ sender: Any) {
        guard let userId = otherUser?.userDetails.id else {
            Logger.error("getting user id"); return
        }
        performUserInteraction(with: String(userId), action: .dislike)
    }
    
}
// MARK: Helper
extension ShowUserDetailsViewController {
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    private func setupUI() {
        backButton.setTitle("", for: .normal)
        handleGradientColors()
        
        guard let otherUser = otherUser else {
            Logger.error("getting other user"); return
        }
        mediaFileList = otherUser.mediaFiles
        viewLike.circleView()
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            
        }
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - DataSource

extension ShowUserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let otherUser = otherUser else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ShowUserDetailsTableItem
            cell.otherUser = otherUser
            cell.blogDelegate = self
            cell.controller = self
            cell.baseVC = self
            cell.isNotification = self.shallNotify
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserAboutCell
            cell.aboutLabel.text = otherUser.userDetails.about.htmlAttributedString
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserImagesCell
            cell.vc = self
            cell.mediaFilesList = otherUser.mediaFiles
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserIntroCell
            cell.otherUser = otherUser
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserLocationCell
            cell.coordinate = otherUser.userDetails.coordinate
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserActivityCell
            if otherUser.userDetails.profile.workStatus.text != "" {
                cell.titleText = "Work"
                let text = otherUser.userDetails
                    .profile.workStatus.text.htmlAttributedString ?? ""
                cell.explanation = text
            }
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserActivityCell
            if otherUser.userDetails.profile.education.text != "" {
                cell.titleText = "Education"
                let text = otherUser.userDetails
                    .profile.education.text.htmlAttributedString ?? ""
                cell.explanation = text
            }
            return cell
            
        case 7:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserActivityCell
            
            if otherUser.userDetails.interest != "" {
                cell.titleText = "Interests"
                let text = otherUser.userDetails.interest.htmlAttributedString ?? ""
                cell.explanation = text
            }
            
            return cell
            
        case 8:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserActivityCell
            
            if otherUser.userDetails.interest != "" {
                cell.titleText = "Language"
                let text =
                otherUser.userDetails.profile.preferredLanguage.text.htmlAttributedString ?? ""
                cell.explanation = text
            }
            return cell
            
        case 9:
            let cell = tableView.dequeueReusableCell(for: indexPath) as UserSocialLinkCell
          //  cell.bind(data: self.object)
            cell.superVC = self
            cell.bindOtherUser(data: otherUser)
            cell.selectionStyle = .none
            return cell
            
        default: return UITableViewCell()
        }

    }
    
}

// MARK: - Delegate

extension ShowUserDetailsViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 430//330.0
        case 1:
            guard let about = otherUser?.userDetails.about else {
                return UITableView.automaticDimension
            }
            return about == "" ? 0 : UITableView.automaticDimension
            
        case 3:
            return otherUser?.mediaFiles.isEmpty ?? true ? 0 : 125
            
        case 2:
            guard let otherUser = otherUser else {
                return 0
            }
            return otherUser.userDetails.profile.description == ""
            && otherUser.userDetails.favourites.description == ""
            ? 0 : UITableView.automaticDimension
            
        case 4:
            guard let latitude = otherUser?.userDetails.coordinate.latitude,
                  let longitude = otherUser?.userDetails.coordinate.longitude else {
                      return 45
            }
            return latitude == "0" || longitude == "0" ? 45 : 165
            
        case 5:
            let workStatus = otherUser?.userDetails.profile.workStatus.text ?? ""
            return workStatus == "" ? 0 : UITableView.automaticDimension
          
        case 6:
            let education = otherUser?.userDetails.profile.education.text ?? ""
            return education == "" ? 0 : UITableView.automaticDimension
            
        case 7:
            let interest = otherUser?.userDetails.interest ?? ""
            return interest == "" ? 0 : UITableView.automaticDimension
            
        case 8:
            let language = otherUser?.userDetails.profile.preferredLanguage.text ?? ""
            return language == "" ? 0 : UITableView.automaticDimension
            
        case 9:
            guard let social = otherUser?.userDetails.socialMedia else {
                return 0
            }
            
            let isEmpty = social.facebook.isEmpty || social.google.isEmpty
            || social.instagram.isEmpty || social.webSite.isEmpty
            
            return isEmpty ? 0 : 95
            
        default:  return 100.0
        }
    }
}

extension ShowUserDetailsViewController: BlogUserDelegate {
    func dislikeUser() {
        self.delegate?.performUserInteraction(with: .dislike)
    }
}
