

import UIKit
import Async
import QuickDateSDK

class InterestPopUpVC: BaseViewController {
    
    var delegate:ReloadTableViewDataDelegate?

    
    @IBOutlet weak var interestTextField: FloatingTextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var interestLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        self.updateInterest()
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    private func setupUI(){
        self.interestLabel.textColor = UIColor.hexStringToUIColor(hex: "FF007F")
               self.cancelBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FF007F"), for: .normal)
                self.submitBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FF007F"), for: .normal)
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
         self.submitBtn.setTitle(NSLocalizedString("Submit", comment: "Submit"), for: .normal)
        interestTextField.setTitle(title: NSLocalizedString("Interest", comment: "Interest"))
        self.interestLabel.text = NSLocalizedString("Interest", comment: "Interest")
        
        self.interestTextField.setLeftPaddingPoints(16)
        self.interestTextField.borderWidthV = 1
        self.interestTextField.borderColorV = UIColor.hexStringToUIColor(hex: "ECECEC")
        
        let appInstance: AppInstance =  .shared
        self.interestTextField.text = appInstance.userProfileSettings?.interest
        
//        let userData =  AppInstance.shared.userProfile
//        self.interestTextField.text = userData["interest"] as? String ?? ""
    }
    private func updateInterest(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let interestString = self.interestTextField.text ?? ""
            
            Async.background({
                ProfileManger.instance.updateInterest(AccessToken: accessToken, InterestText: interestString, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.debug("UPDATED")
                                self.dismiss(animated: true) {
                                    self.delegate?.reloadTableView(Status: true)
                                }
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
