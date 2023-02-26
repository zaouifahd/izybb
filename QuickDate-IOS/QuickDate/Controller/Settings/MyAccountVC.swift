//
//  MyAccountVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class MyAccountVC: BaseViewController {
    
    @IBOutlet weak var myAccountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var userNameText: FloatingTextField!
    @IBOutlet var emailText: FloatingTextField!
    @IBOutlet var phoneText: FloatingTextField!
    @IBOutlet var countryText: FloatingTextField!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewBtnSave: UIView!
    
    // MARK: - Properties
    
    private let appInstance: AppInstance = .shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        configView()
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
    
    //MARK:- Methods
    func configView() {
    }
    
    private func setupUI(){
        self.myAccountLabel.text = NSLocalizedString("My Account", comment: "My Account")
        self.userNameText.setTitle(title: NSLocalizedString("Username", comment: "Username"))
        self.emailText.setTitle(title: NSLocalizedString("Email", comment: "Email"))
        self.phoneText.setTitle(title: NSLocalizedString("Phone Number", comment: "Phone Number"))
        self.countryText.setTitle(title: NSLocalizedString("Country", comment: "Country"))
        self.lblSave.text = NSLocalizedString("SAVE", comment: "SAVE")
        
        self.userNameText.text = appInstance.userProfileSettings?.username
        self.emailText.text = appInstance.userProfileSettings?.email
        self.phoneText.text = appInstance.userProfileSettings?.phoneNumber
        self.countryText.text = appInstance.userProfileSettings?.country
        viewBtnSave.cornerRadiusV = viewBtnSave.bounds.height / 2
    }
   
    private func updateUserAccount(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let username = self.userNameText.text ?? ""
            let email = self.emailText.text ?? ""
            let phoneNo = self.phoneText.text ?? ""
            let country = self.countryText.text ?? ""
            Async.background({
                ProfileManger.instance.updateAccount(AccessToken: accessToken, username: username, email: email, phone: phoneNo, country: country, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.debug("UPDATED")
//                                AppInstance.shared.fetchUserProfile(view: self.view, completion: {
//                                     Logger.debug("UPDATED")
//                                })
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
    
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        updateUserAccount()

    }
}
