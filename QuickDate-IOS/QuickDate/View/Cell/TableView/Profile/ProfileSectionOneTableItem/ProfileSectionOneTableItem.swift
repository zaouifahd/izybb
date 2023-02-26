//
//  ProfileSectionOneTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class ProfileSectionOneTableItem: UITableViewCell {
    
    @IBOutlet weak var visitBtn: UIButton!
    @IBOutlet weak var likesBtn: UIButton!
   // @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var boostMeLabel: UILabel!
   // @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var verifiedIcon: UIImageView!
    @IBOutlet weak var boostMeTimerLabel: UILabel!
   // @IBOutlet var myProfileBgrView: UIView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var creditsButton: UIButton!
    @IBOutlet var popularityButton: UIButton!
    @IBOutlet var lifeTimeButton: UIButton!
    @IBOutlet var boostMeButton: UIButton!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var btnUserAddress: UIButton!
    //  @IBOutlet weak var visitLabel: UILabel!
   // @IBOutlet weak var likeLabel: UILabel!
    var vc: ProfileVC!
    private let imagePickerController = UIImagePickerController()
    
    // MARK: - Properties
    private let userSettings = AppInstance.shared.userProfileSettings
    private let appNavigator: AppNavigator = .shared
    var seconds = 240
    var timer = Timer()
    var isTimerRunning = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configView()
    }
    
    @IBAction func onBtnVisit(_ sender: Any) {
        let visitsVC = VisitsVC.instantiate(fromStoryboardNamed: .main)
        visitsVC.isProfileNavgation = true
        self.vc.navigationController?.pushViewController(visitsVC, animated: true)
    }
    @IBAction func settingsButtonAction(_ sender: Any) {
        let vc = R.storyboard.settings.settingsVC()
        self.vc.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func editButtonAction(_ sender: Any) {
        let vc = R.storyboard.settings.profileVC()
        self.vc?.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func creditsButtonAction(_ sender: Any) {
        let vc = R.storyboard.credit.buyCreditVC()
        vc?.delegate = self
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .overFullScreen
        self.vc.present(vc!, animated: true, completion: nil)
        
    }
    @IBAction func popularityButtonAction(_ sender: Any) {
        let vc = R.storyboard.main.boostVC()
        vc?.delegate = self
        self.vc.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @IBAction func lifeTimeButtonAction(_ sender: Any) {
//        if AppInstance.shared.userProfile["is_pro"] as? String == "1"{
        if userSettings?.isProUser ?? false {
            let vc = R.storyboard.popUps.premiumPopupVC()
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .fullScreen
            self.vc.present(vc!, animated: true, completion: nil)
        }else{
            let vc = R.storyboard.credit.upgradeAccountVC()
            vc?.delegate = self
            vc?.superVC = vc
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .fullScreen
            self.vc.present(vc!, animated: true, completion: nil)
        }
    }
    
    @IBAction func boostMeButtonAction(_ sender: Any) {
        
        self.boostPopularity(type: "boost")
    }
    
    @IBAction func onBtnShare(_ sender: Any) {
        let appInstance: AppInstance = .shared
        appInstance.addCount = appInstance.addCount + 1
        let text = "\(API.baseURL)@\(appInstance.userProfileSettings?.username ?? "")"
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.vc.view
        self.vc.present(activityViewController, animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  self.creditsButton.backgroundColor = .Main_StartColor
       //  self.popularityButton.backgroundColor = .Main_StartColor
       //  self.lifeTimeButton.backgroundColor = .Main_StartColor
        //    self.likesBtn.backgroundColor = .Main_StartColor
         //   self.visitBtn.backgroundColor = .Main_StartColor
        self.lifeTimeButton.setTitle(NSLocalizedString("Upgrade", comment: "Upgrade"), for: .normal)
     //   self.settingsLabel.text = NSLocalizedString("Settings", comment: "Settings")
        self.boostMeLabel.text = NSLocalizedString("Boost Me", comment: "Boost Me")
       // self.editProfileLabel.text = NSLocalizedString("Edit Profile", comment: "Edit Profile")
        let imageOneTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView1Tapped(_:)))
        self.avatarImage.addGestureRecognizer(imageOneTapped)
//        let likesCount = AppInstance.shared.userProfile["likes_count"] as? Int
//        let visitCount = AppInstance.shared.userProfile["visits_count"] as? Int
        
        let likesCount = userSettings?.likesCount
        let visitCount = userSettings?.visitsCount
        //self.likeLabel.text =  "\(likesCount ?? 0) \(NSLocalizedString("Likes", comment: "Likes"))"
        self.likesBtn.setTitle("\(likesCount ?? 0) \(NSLocalizedString("Likes", comment: "Likes"))", for: .normal)
        self.visitBtn.setTitle("\(visitCount ?? 0) \(NSLocalizedString("Visits", comment: "Visits"))", for: .normal)
        self.likesBtn.addTarget(self, action: #selector(onBtnLike), for: .touchUpInside)
       // self.visitLabel.text =  "\(visitCount ?? 0) \(NSLocalizedString("Visits", comment: "Visits"))"
        self.requestLocationServiceAccess()
    }
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer() {
        seconds -= 1
        self.boostMeTimerLabel.text = timeString(time: TimeInterval(seconds))
        if self.seconds == 0{
            self.timer.invalidate()
            self.boostMeTimerLabel.text = "Boost Me"
            self.boostMeButton.isEnabled = true
            self.seconds = 120
        }else{
            self.boostMeButton.isEnabled = false
        }
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",minutes, seconds)
    }
    
    @objc func ImageView1Tapped(_ sender:UITapGestureRecognizer){
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: NSLocalizedString("Select Source", comment: "Select Source"), preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: "Camera"), style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title:NSLocalizedString("Gallery", comment: "Gallery") , style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    
    @objc func onBtnLike() {
        if userSettings?.isProUser ?? false {
            let vc = R.storyboard.popUps.premiumPopupVC()
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .fullScreen
            self.vc.present(vc!, animated: true, completion: nil)
        }else{
            let vc = R.storyboard.credit.upgradeAccountVC()
            vc?.delegate = self
            vc?.superVC = vc
            vc?.modalTransitionStyle = .coverVertical
            vc?.modalPresentationStyle = .fullScreen
            self.vc.present(vc!, animated: true, completion: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - Methods
    func configView() {
        settingsButton.circleView()
        editButton.circleView()
        boostMeButton.circleView()
        creditsButton.circleView()
        popularityButton.circleView()
        lifeTimeButton.circleView()
        avatarImage.circleView()
        editButtonView.circleView()
      //  myProfileBgrView.halfCircleView()
        vc.viewDidLayoutSubviews()
    }
    
    func requestLocationServiceAccess() {
        AppLocationManager.shared.requestLocationServiceIfNeed(force: false) { (granted) in
            if granted {
                self.startLocationUpdate()
            } else {
            }
        }
    }
    
    func startLocationUpdate() {
        AppLocationManager.shared.startLocationUpdate { (currentLocation) in
            GetMapAddress.getAddress(selectedLat: currentLocation.latitude, selectedLon: currentLocation.longitude) { stAddress in
                self.btnUserAddress.setTitle(stAddress, for: .normal)
            }
        }
    }
    
    func configData() {
//        let url = URL(string: AppInstance.shared.userProfile["avater"] as? String ?? "")
        let url = URL(string: userSettings?.avatar ?? "")
        avatarImage.sd_setImage(with: url, placeholderImage: R.image.no_profile_image())
//        usernameLabel.text = AppInstance.shared.userProfile["username"] as? String ?? ""
        usernameLabel.text = userSettings?.fullName ?? ""
//        self.creditsButton.setTitle(AppInstance.shared.userProfile["balance"] as? String ?? "0.0", for: .normal )
        self.creditsButton.setTitle("\(userSettings?.balance ?? 0.0)", for: .normal )
        
//        if AppInstance.shared.userProfile["is_pro"] as? String == "1"{
        
        self.verifiedIcon.isHidden = !(userSettings?.isProUser ?? false)
        
//        if userSettings?.isProUser ?? false {
//            self.verifiedIcon.isHidden = false
//        }else{
//            self.verifiedIcon.isHidden = true
//        }
    }
    
}
extension  ProfileSectionOneTableItem:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.avatarImage.image = image
        self.vc.dismiss(animated: true, completion: nil)
        self.updateAvatar(Image: image)
        
    }
    private func updateAvatar(Image:UIImage){
        if Connectivity.isConnectedToNetwork(){
            self.vc.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let avatarImageData = Image.jpegData(compressionQuality: 0.2)
            Async.background({
                UpdateAvatarManager.instance.updateAvatar(AccesToken:accessToken , AvatarData: avatarImageData, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.debug("success = \(success?.data ?? "")")
                                self.vc.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                
//                                AppInstance.shared.fetchUserProfile(view: self.vc.view, completion: {
//
//                                })
                            }
                        })
                        
                    }else if sessionError != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.vc.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.vc.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
                
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.vc.view.makeToast(InterNetError)
        }
        
    }
    private func boostPopularity(type:String){
        if Connectivity.isConnectedToNetwork(){
            self.vc.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                PopularityManager.instance.managePopularity(AccessToken: accessToken, Type: type, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.vc.view.makeToast(success?.message ?? "")
                                    self.runTimer()
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                let vc = R.storyboard.credit.buyCreditVC()
                                vc?.delegate = self
                                vc?.modalTransitionStyle = .coverVertical
                                vc?.modalPresentationStyle = .overFullScreen
                               self.vc.present(vc!, animated: true, completion: nil)
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.vc.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc.dismissProgressDialog {
                                self.vc.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
                
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.vc.view.makeToast(InterNetError)
        }
        
    }
    
}
extension ProfileSectionOneTableItem: MoveToPayScreenDelegate {
    func moveToAuthorizeNetPayScreen(status: Bool, payingInfo: PayingInformation) {
        let viewController = PayVC.instantiate(fromStoryboardNamed: .credit)
        viewController.payInfo = payingInfo
        viewController.isAuthorizeNet = true
        vc?.navigationController?
            .pushViewController(viewController, animated: true)
    }
    
    
    func moveToPayScreen(status: Bool, payingInfo: PayingInformation) {
        if status {
            let viewController = PayVC.instantiate(fromStoryboardNamed: .credit)
            viewController.payInfo = payingInfo
            vc?.navigationController?
                .pushViewController(viewController, animated: true)
        } else {
            let viewController = BankTransferVC.instantiate(fromStoryboardNamed: .credit)
            viewController.payInfo = payingInfo
            vc?.navigationController?
                .pushViewController(viewController, animated: true)
        }
    }
    
//    func moveToPayScreen(status: Bool, payType: String?, amount: Int, description: String,membershipType:Int?,credits:Int?) {
//        if !status{
//            let vc = R.storyboard.credit.bankTransferVC()
//            vc?.payType = payType ?? ""
//            vc?.amount = amount
//            vc?.Description = description
//            vc?.memberShipType = membershipType
//            vc?.credits = credits ?? 0
//            self.vc.navigationController?.pushViewController(vc!, animated: true)
//        }else{
//            let vc = R.storyboard.credit.payVC()
//            vc?.payType = payType ?? ""
//            vc?.amount = amount
//            vc?.Description = description
//            vc?.memberShipType = membershipType
//            vc?.credits = credits ?? 0
//            self.vc.navigationController?.pushViewController(vc!, animated: true)
//            
//        }
//        
//    }
    
    
}
