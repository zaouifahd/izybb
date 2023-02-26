//
//  WithdrawalsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

class WithdrawalsVC: BaseViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var widthdrawalLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var viewAmount: UIView!
    @IBOutlet weak var viewPayPalEmail: UIView!
    
    var email:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    private func setupUI(){
        self.balanceLabel.text = NSLocalizedString("MY BALANCE", comment: "MY BALANCE")
        self.amountText.placeholder = NSLocalizedString("Amount", comment: "Amount")
        self.emailTextField.placeholder = NSLocalizedString("PayPal E-mail", comment: "PayPal E-mail")
        self.amountLabel.text = "\(AppInstance.shared.adminAllSettings?.data?.currencySymbol ?? "$")" + "\(AppInstance.shared.userProfileSettings?.balance ?? 0.0)"
        viewAmount.cornerRadiusV = viewAmount.bounds.height / 2
        viewPayPalEmail.cornerRadiusV = viewPayPalEmail.bounds.height / 2
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let amountValue = self.amountText.text ?? ""
        let accessToken = AppInstance.shared.accessToken ?? ""
        if Int(amountValue) ?? 0 >= 50 && !self.emailTextField.text!.isEmpty{
            self.showProgressDialog(with: "Loading...")
            let email = self.emailTextField.text ?? ""
            Async.background({
                WithdrawalsManager.instance.requestWithdrawals(AccessToken: accessToken, amount: amountValue, email: email) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                            
                        })
                        
                    }else {
                        
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription)")
                                self.view.makeToast(error?.localizedDescription)
                            }
                            
                        })
                    }
                }
            })
        }else if amountValue == nil {
            self.view.makeToast(NSLocalizedString("Please enter amount.", comment: "Please enter amount."))
        }else if self.emailTextField.text!.isEmpty{
            self.view.makeToast(NSLocalizedString("Please enter email.", comment: "Please enter email."))
        }else if !self.emailTextField.text!.isEmail{
            self.view.makeToast(NSLocalizedString("Email is badly formatted.", comment: "Email is badly formatted."))
        }
        else{
            self.view.makeToast(NSLocalizedString("Amount shouldn't be less than 50.", comment: "Amount shouldn't be less than 50."))
        }
    }
    
}
