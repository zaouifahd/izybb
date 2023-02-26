

import UIKit
import Async
import QuickDateSDK

protocol ReloadTableViewDataDelegate {
    func reloadTableView(Status:Bool)
}
class AboutMePopUpVC: BaseViewController {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutMetextFIeld: FloatingTextField!
    var delegate:ReloadTableViewDataDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    @IBAction func submitPressed(_ sender: Any) {
        updateAboutMe()
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI(){
        self.aboutLabel.textColor = UIColor.hexStringToUIColor(hex: "FF007F")
        self.cancelBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FF007F"), for: .normal)
         self.submitBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "FF007F"), for: .normal)
        self.aboutMetextFIeld.setLeftPaddingPoints(16)
        self.aboutMetextFIeld.borderWidthV = 1
        self.aboutMetextFIeld.borderColorV = UIColor.hexStringToUIColor(hex: "ECECEC")
        self.aboutLabel.text = NSLocalizedString("About", comment: "About")
        self.aboutMetextFIeld.setTitle(title: NSLocalizedString("About me", comment: "About me"))
        self.cancelBtn.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        self.submitBtn.setTitle(NSLocalizedString("Submit", comment: "Submit"), for: .normal)
        let appInstance: AppInstance = .shared
        self.aboutMetextFIeld.text = appInstance.userProfileSettings?.about 
//        let userData =  AppInstance.shared.userProfile ?? [:]
//        self.aboutMetextFIeld.text = userData["about"] as? String ?? ""
    }
    private func updateAboutMe(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let aboutMeString = self.aboutMetextFIeld.text ?? ""
            
            Async.background({
                ProfileManger.instance.updateAboutMe(AccessToken: accessToken, AboutMeText: aboutMeString, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                self.delegate?.reloadTableView(Status: true)
                                
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
