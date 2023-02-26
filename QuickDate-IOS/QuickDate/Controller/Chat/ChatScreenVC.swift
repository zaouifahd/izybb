//
//  ChatScreenVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import DropDown
import FittedSheets
import IQKeyboardManagerSwift
import SwiftEventBus
import QuickDateSDK

class ChatScreenVC: BaseViewController {
    
 //  @IBOutlet weak var upperPrimaryView: UIView!
   // @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var videoBtn: UIButton!
    @IBOutlet weak var audioBtn: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var receiverNameLabel: UILabel!
    @IBOutlet var lastSeenLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var inputMessageView: UIView!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var giftButton: UIButton!
    @IBOutlet var stickerButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var topNavigationView: UIView!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var viewChat: UIView!
    
    // MARK: - Properties
    private let networkManager: NetworkManager = .shared
    private let userSettings = AppInstance.shared.userProfileSettings
    private let appNavigator: AppNavigator = .shared
    
    var chatList: [[String:Any]] = []
    var toUserId:String? = ""
    var usernameString:String? = ""
    var lastSeenString:String? = ""
    var lastSeen:String? = ""
    var profileImageString:String? = ""
    private var messageCount:Int? = 0
    private var scrollStatus:Bool? = true
    private let moreDropdown = DropDown()
    private let imagePickerController = UIImagePickerController()
    
    private var userProfile: UserProfile?
    
    var a = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.customizeDropdown()
        Logger.verbose("To USerId = \(self.toUserId ?? "")")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        topNavigationView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 20)
    }
    
    deinit {
        SwiftEventBus.unregister(self)
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func animatedKeyBoard(scrollToBottom: Bool) {
        UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            if scrollToBottom {
                self.view.layoutIfNeeded()
            }
        }, completion: { (completed) in
            if scrollToBottom {
                if !self.chatList.isEmpty {
                    let indexPath = IndexPath(item: self.chatList.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        })
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        hideNavigation(hide: true)
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_CONNECTED) { result in
            self.fetchData()
        }
        SwiftEventBus.onMainThread(self, name: EventBusConstants.EventBusConstantsUtils.EVENT_INTERNET_DIS_CONNECTED) { result in
            Logger.verbose("Internet dis connected!")
        }
        hideTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserProfile()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        showTabBar()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    @IBAction func callPressed(_ sender: Any) {
        let vc = R.storyboard.call.callVC()
        vc?.toUSerId = self.toUserId ?? ""
        vc?.username = self.usernameString ?? ""
        vc?.callingType = "voiceCall"
        vc?.delegate = self
        vc?.profileImageString = self.profileImageString ?? ""
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func videoPressed(_ sender: Any) {
        let vc = R.storyboard.call.callVC()
        vc?.toUSerId = self.toUserId ?? ""
        vc?.username = self.usernameString ?? ""
        vc?.callingType = "videoCall"
        vc?.profileImageString = self.profileImageString ?? ""
        vc?.delegate = self
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    // MARK: - Methods
    
    private func setupUI(){
        self.messageTextfield.placeholder = NSLocalizedString("Write your message", comment: "Write your message")
        self.receiverNameLabel.text = self.usernameString ?? ""
        self.lastSeenLabel.text = setTimestamp(epochTime: self.lastSeenString ?? "").replacingOccurrences(of: "-", with: "")
        tableView.delegate = self
        tableView.dataSource = self
        self.sendBtn.circleView()
        self.viewChat.circleView()

        let chatStickerSenderCell = UINib(nibName: "ChatStickerSenderCell", bundle: nil)
        self.tableView.register(chatStickerSenderCell, forCellReuseIdentifier: R.reuseIdentifier.chatStickerSenderCell.identifier)
        
        let chatStickerReceiverCell = UINib(nibName: "ChatStickerReceiverCell", bundle: nil)
        self.tableView.register(chatStickerReceiverCell, forCellReuseIdentifier: R.reuseIdentifier.chatStickerReceiverCell.identifier)
        
        let chatSenderTableItem = UINib(nibName: "ChatSenderTableItem", bundle: nil)
        self.tableView.register(chatSenderTableItem, forCellReuseIdentifier: R.reuseIdentifier.chatSenderTableItem.identifier)
                
        let chatReceiverTableItem = UINib(nibName: "ChatReceiverTableItem", bundle: nil)
        self.tableView.register(chatReceiverTableItem, forCellReuseIdentifier: R.reuseIdentifier.chatReceiverTableItem.identifier)
        
        let senderImageTableItem = UINib(nibName: "SenderImageTableItem", bundle: nil)
        self.tableView.register(senderImageTableItem, forCellReuseIdentifier: R.reuseIdentifier.senderImageTableItem.identifier)
        
        let ReceiverImageTableItem = UINib(nibName: "ReceiverImageTableItem", bundle: nil)
        self.tableView.register(ReceiverImageTableItem, forCellReuseIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier)
        
        imageViewProfile.circleView()
        let url = URL(string: profileImageString ?? "")
        self.imageViewProfile.sd_setImage(with: url, placeholderImage: R.image.thumbnail())

        if userSettings?.isProUser ?? false {
            self.videoBtn.isHidden = false
            self.audioBtn.isHidden = false
        }else{
            self.videoBtn.isHidden = true
            self.audioBtn.isHidden = true
        }
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    func customizeDropdown() {
        moreDropdown.dataSource = [
            "View Profile".localized,
            NSLocalizedString("Block", comment: "Block"),
            NSLocalizedString("Clear chat", comment: "Clear chat")]
        moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
        moreDropdown.textColor = UIColor.white
        moreDropdown.anchorView = self.menuButton
        //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
        moreDropdown.width = 200
        moreDropdown.direction = .any
        
        moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                self.goToUserProfile()
            } else if index == 1{
                self.blockUser()
                
            } else if index == 2{
                self.clearChat()
            }
            
        }
        
    }
    private func goToUserProfile() {
        guard let userProfile = userProfile else {
            Logger.error("getting userProfile"); return
        }
        appNavigator.dashboardNavigate(to: .userDetail(user: .userProfile(userProfile), delegate: .none))
    }
    
    private func fetchUserProfile() {
        let accessToken = AppInstance.shared.accessToken ?? ""
        guard let toUserId = toUserId else {
            Logger.error("getting toUserId"); return
        }

        let params: APIParameters = [
            API.PARAMS.user_id: "\(toUserId)",
            API.PARAMS.access_token: accessToken,
            API.PARAMS.fetch: "data,media"
        ]
        
        Async.background({
            self.networkManager.fetchDataWithRequest(
                urlString: API.USERS_CONSTANT_METHODS.PROFILE_API,
                method: .post,
                parameters: params,
                successCode: .code) { [weak self] response in
                    switch response {
                    case .failure(let error): Logger.error(error)
                        
                    case .success(let json):
                        guard let data = json["data"] as? JSON else {
                            Logger.error("getting data"); return
                        }
                        let userProfile = UserProfile(dict: data)
                        self?.userProfile = userProfile
                    }
                }
        })
    }
    
    private func fetchData(){
        if Connectivity.isConnectedToNetwork(){
            chatList.removeAll()
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            
            Async.background({
                ChatManager.instance.getChatConversation(AccessToken: accessToken, To_userId: toID, Limit: 100, Offset: 0, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.chatList = success?.data ?? []
                                self.tableView.reloadData()
                                if self.scrollStatus!{
                                    if self.chatList.count == 0{
                                        Logger.verbose("Will not scroll more")
                                    }else{
                                        self.scrollStatus = false
                                        self.messageCount = self.chatList.count ?? 0
                                        let indexPath = NSIndexPath(item: ((self.chatList.count) - 1), section: 0)
                                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                        
                                    }
                                }else{
                                    if self.chatList.count > self.messageCount!{
                                        
                                        self.messageCount = self.chatList.count ?? 0
                                        let indexPath = NSIndexPath(item: ((self.chatList.count) - 1), section: 0)
                                        self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                                    }else{
                                        Logger.verbose("Will not scroll more")
                                    }
                                    Logger.verbose("Will not scroll more")
                                }
                            }
                            
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message  ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
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
    
    
    private func sendSticker() {
        
    }
    
    private func sendMedia() {
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .alert)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title:NSLocalizedString("Gallery", comment: "Gallery") , style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    private func sendMessage(){
        let messageHashId = Int(arc4random_uniform(UInt32(100000)))
        let messageText = messageTextfield.text ?? ""
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendMessage(AccessToken: accessToken, To_userId: toID, Message: messageText, Hash_Id: messageHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            Logger.debug("userList = \(success?.message ?? "")")
                            self.view.makeToast(success?.message ?? "")
                            
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
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
    }
    
    private func clearChat(){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            
            Async.background({
                ChatManager.instance.clearChat(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
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
    
    private func blockUser(){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(with: "Loading...")
            
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.toUserId ?? "") ?? 0
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
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
    func setTimestamp(epochTime: String) -> String {
        let currentDate = Date()
        
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) ?? 0.0)
        
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)
        
        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second ago"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds ago"
                        }
                        
                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute ago"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes ago"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour ago"
                } else {
                    return String(currentHour - epochHour) + " hours ago"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day ago"
            } else {
                return String(currentDay - epochDay) + " days ago"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }
    func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "h:mm a"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "\(dateString)"
    }
    
    
    // MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        self.moreDropdown.show()
        
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        self.sendMessage()
        
        self.messageTextfield.text = ""
        
    }
    
    @IBAction func imageButtonAction(_ sender: Any) {
        self.sendMedia()
    }
    
    @IBAction func stickerButtonAction(_ sender: Any) {
        let vc = R.storyboard.chat.stickersViewController()
        let controller = SheetViewController(controller:vc!)
        controller.hasBlurBackground = true
        vc?.stickerDelegate = self
        vc?.checkStatus = false
        self.present(controller, animated: false, completion: nil)
        
    }
    
    @IBAction func giftButtonAction(_ sender: Any) {
        let vc = R.storyboard.chat.stickersViewController()
        let controller = SheetViewController(controller:vc!)
        controller.hasBlurBackground = true
        vc?.giftDelegate = self
        vc?.checkStatus = true
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func emoButtonAction(_ sender: Any) {
    }
}

// MARK: - TableView

extension ChatScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.chatList.isEmpty{
            return UITableView.automaticDimension
        }else{
            let object = self.chatList[indexPath.row] ?? nil
            let messageType  = object?["message_type"] as? String
            switch messageType {
            case "media":
                return 200
            case "sticker":
                return 200
            default:
                return UITableView.automaticDimension
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.chatList.count == 0{
            return UITableViewCell()
            
        }else{
            let object = chatList[indexPath.row]
            let messageType  = object["message_type"] as? String
            let from = object["from"] as? Int
            
            if messageType == "text"{
                if from == AppInstance.shared.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatReceiverTableItem.identifier) as? ChatReceiverTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.chatSenderTableItem.identifier) as? ChatSenderTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }
            }else if messageType ==  "sticker"{
                if from == AppInstance.shared.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier) as? ReceiverImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.senderImageTableItem.identifier) as? SenderImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }
            }else {
                if from == AppInstance.shared.userId {
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.receiverImageTableItem.identifier) as? ReceiverImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.senderImageTableItem.identifier) as? SenderImageTableItem
                    cell?.selectionStyle = .none
                    cell?.bind(object)
                    return cell!
                }
            }
        }
    }
}

// MARK: - ImagePicker
extension  ChatScreenVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let convertedImageData = image.jpegData(compressionQuality: 0.2)
        self.sendMedia(ImageData: convertedImageData!)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func sendMedia(ImageData:Data){
        let mediaHashId = Int(arc4random_uniform(UInt32(100000)))
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendMedia(AccessToken: accessToken, To_userId: toID, Hash_Id: mediaHashId, MediaData: ImageData, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
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
    }
}

// MARK: - StickerDelegate
extension ChatScreenVC: StickerDelegate{
    func selectSticker(with stickerId: Int) {
        sendSticker(stickerID: stickerId)
    }
    private func sendSticker(stickerID:Int){
        let stickerHashId = Int(arc4random_uniform(UInt32(100000)))
        let stickerId = stickerID
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendSticker(AccessToken: accessToken, To_userId: toID, StickerId: stickerId, Hash_Id: stickerHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            self.view.makeToast(sessionError?.message ?? "")
                            Logger.error("sessionError = \(sessionError?.message ?? "")")
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
    }
    
}

// MARK: - GiftDelegate

extension ChatScreenVC: GiftDelegate{
    
    func selectGift(with giftId: Int) {
        sendGift(giftID: giftId)
    }
    private func sendGift(giftID:Int){
        let giftHashId = Int(arc4random_uniform(UInt32(100000)))
        let giftId = giftID
        let toID = Int(self.toUserId ?? "") ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            ChatManager.instance.sendGift(AccessToken: accessToken, To_userId: toID, GiftId: giftID, Hash_Id: giftHashId, completionBlock: { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            
                            self.view.makeToast(sessionError?.errors?.errorText ?? "")
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
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
    }
    
}

// MARK: - ReceiveCallDelegate
//extension ChatScreenVC:ReceiveCallDelegate{
//    func receiveCall(status: Bool, profileImage: String, CallId: Int, AccessToken: String, RoomId: String, username: String, isVoice: Bool) {
//        if isVoice{
//            let vc = R.storyboard.call.voiceCallVC()
////            vc?.accessToken = AccessToken
//            vc?.roomID = RoomId
//            vc?.callID = CallId
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }else{
//            let vc = R.storyboard.call.tempVCalling()
//            vc?.accessToken = AccessToken
//            vc?.roomId = RoomId
//            vc?.modalPresentationStyle = .fullScreen
//            self.present(vc!, animated: true, completion: nil)
//        }
//        
//    }
//    
//    
//}
