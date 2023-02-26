//
//  TwoFactorUpdateVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import Async
import DropDown
import GoogleMobileAds

protocol TwoFactorAuthDelegate {
    func getTwoFactorUpdateString(type:String)
}

class TwoFactorUpdateVC: BaseViewController {
    @IBOutlet weak var saveBtn: UIButton!
    
    
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var selectBtn: UIButton!
    //    var bannerView: GADBannerView!
    
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var twoFactorLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    private let moreDropdown = DropDown()
    var bannerView: GADBannerView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    var typeString:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setupUI(){
        self.customizeDropdown()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Two Factor Authentication"
        
        
        self.twoFactorLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
        self.textLabel.text = NSLocalizedString("Turn on 2-step login to level-up your account security. Once turned on, you'll use both your password and a 6-digit security code send to your  phone or email to log in.", comment: "Turn on 2-step login to level-up your account security. Once turned on, you'll use both your password and a 6-digit security code send to your  phone or email to log in.")
        lblSave.text = NSLocalizedString("SAVE", comment: "SAVE")
        Logger.verbose("AppInstance.instance.userProfile?.data?.twoFactor = \(appInstance.userProfileSettings?.twoFactorVerified)")
        self.typeString = self.selectBtn.titleLabel?.text ?? ""
        self.viewSave.cornerRadiusV = self.viewSave.bounds.height / 2
//        if AppInstance.shared.userProfile["two_factor"] as? String == "0"{
        if appInstance.userProfileSettings?.twoFactor ?? false {
            self.selectBtn.setTitle(NSLocalizedString("Disable", comment: "Disable"), for: .normal)
        }else{
            self.selectBtn.setTitle(NSLocalizedString("Enable", comment: "Enable"), for: .normal)
        }
                if ControlSettings.shouldShowAddMobBanner{
        
                    bannerView = GADBannerView(adSize: GADAdSizeBanner)
                    addBannerViewToView(bannerView)
                    bannerView.adUnitID = ControlSettings.addUnitId
                    bannerView.rootViewController = self
                    bannerView.load(GADRequest())
                }
    }
        func addBannerViewToView(_ bannerView: GADBannerView) {
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            view.addConstraints(
                [NSLayoutConstraint(item: bannerView,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: bottomLayoutGuide,
                                    attribute: .top,
                                    multiplier: 1,
                                    constant: 0),
                 NSLayoutConstraint(item: bannerView,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: view,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
            ])
        }
    
    @IBAction func selectBtnPressed(_ sender: Any) {
        moreDropdown.show()
        
    }
    @IBAction func savePressed(_ sender: Any) {
        self.showProgressDialog(with: "Loading")
//        if AppInstance.shared.userProfile["two_factor_verified"] as? String == "1"{
        if appInstance.userProfileSettings?.twoFactorVerified ?? false {
            self.updateTwoFactorSendCode(twofactor:self.typeString ?? "")
        }else{
            self.sendVerificationCode()
            
        }
        
    }
    func customizeDropdown(){
          moreDropdown.dataSource = [NSLocalizedString("Disable", comment: "Disable"),NSLocalizedString("Enable", comment: "Enable")]
          moreDropdown.backgroundColor = UIColor.hexStringToUIColor(hex: "454345")
          moreDropdown.textColor = UIColor.white
          moreDropdown.anchorView = self.selectBtn
          //        moreDropdown.bottomOffset = CGPoint(x: 312, y:-270)
          moreDropdown.width = 200
          moreDropdown.direction = .any
          moreDropdown.selectionAction = { [unowned self] (index: Int, item: String) in
              if index == 0{
                self.typeString = "0"
                self.selectBtn.setTitle(NSLocalizedString("Disable", comment: "Disable"), for: .normal)
                  
              }else if index == 1{
                 self.typeString = "1"
                 self.selectBtn.setTitle(NSLocalizedString("Enable", comment: "Enable"), for: .normal)
              }
              
              print("Index = \(index)")
          }
    }
    private func updateTwoFactorSendCode(twofactor:String){
        self.showProgressDialog(with: "Loading...")
       let userID = AppInstance.shared.userId ?? 0
              let accessToken = AppInstance.shared.accessToken ?? ""
        Async.background({
            ProfileManger.instance.updateTwoFactorProfile(UserId: userID, AccessToken: accessToken, twoFactor: twofactor) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
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
                            self.view.makeToast(error?.localizedDescription)
                            Logger.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            }
        })
    }
    private func sendVerificationCode(){
//        let email = AppInstance.shared.userProfile["email"] as? String ?? ""
//        let email = AppInstance.shared.userProfile["email"] as? String ?? ""
        let email = appInstance.userProfileSettings?.email ?? ""
        let userID = AppInstance.shared.userId ?? 0
        let accessToken = AppInstance.shared.accessToken ?? ""
        Async.background({
            ProfileManger.instance.updateTwoaFactor(UserId: userID, AccessToken: accessToken, email: email) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(success?.message ?? "")
                            let appManager: AppManager = .shared
                            appManager.fetchUserProfile()
                            
                            let vc = R.storyboard.settings.updateTwoFactorSettingPopupVC()
                            vc?.modalTransitionStyle = .coverVertical
                            vc?.modalPresentationStyle = .fullScreen
                            self.present(vc!, animated: true, completion: nil)
                           
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(sessionError?.errors?.errorText)
                            Logger.error("sessionError = \(sessionError?.errors?.errorText)")
                            
                        }
                    })
                }else {
                    Async.main({
                        self.dismissProgressDialog {
                            self.view.makeToast(error?.localizedDescription)
                            Logger.error("error = \(error?.localizedDescription)")
                        }
                    })
                }
            }
        })
    }
}
