//
//  DeleteAccountVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

import Async
import QuickDateSDK

class DeleteAccountVC: BaseViewController {

    @IBOutlet weak var bottonLabel: UILabel!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var passwordTextField: FloatingTextField!
    @IBOutlet var removeAccountButton: UIButton!
    @IBOutlet var switcher: UISwitch!
    @IBOutlet weak var lblRemoveAccount: UILabel!
    @IBOutlet weak var viewRemoveAccount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK: - Methods
    func setupUI() {
        self.deleteAccountLabel.text = NSLocalizedString("Delete Account", comment: "Delete Account")
        self.passwordTextField.setTitle(title: NSLocalizedString("Password", comment: "Password"))
        self.bottonLabel.text = NSLocalizedString("Yes, I want to delete Username permanently from QuickDate Account.", comment: "Yes, I want to delete Username permanently from QuickDate Account.")
        self.lblRemoveAccount.text = NSLocalizedString("REMOVE ACCOUNT", comment: "REMOVE ACCOUNT")
        viewRemoveAccount.cornerRadiusV = viewRemoveAccount.bounds.height / 2
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func removeAccountButtonAction(_ sender: Any) {
        if switcher.isOn {
            if self.passwordTextField.text!.isEmpty{
                self.view.makeToast("Please enter password")
            }else{
                self.deleteAccount()
            }
        }else{
            self.view.makeToast("Please verify you want to delete the your account parmanently")
        }
    }
    private func deleteAccount(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let password = self.passwordTextField.text ?? ""
            Async.background({
                UserManager.instance.deleteAccount(AccessToken: accessToken, Password: password, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                UserDefaults.standard.removeObject(forKey: Local.USER_SESSION.User_Session)
                                let vc = R.storyboard.authentication.main()
                                self.appDelegate.window?.rootViewController = vc
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
}
