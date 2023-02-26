
import UIKit
import Async
import QuickDateSDK

class UnblockUserPopUpVC: BaseViewController {

    var UserID:String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func yesPressed(_ sender: Any) {
        self.unBlockUser()
    }
    
    @IBAction func noPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func unBlockUser(){
        if Connectivity.isConnectedToNetwork(){
            
            self.showProgressDialog(with: "Loading...")
            
            let accessToken = AppInstance.shared.accessToken ?? ""
            let toID = Int(self.UserID ?? "") ?? 0
            
            Async.background({
                BlockUserManager.instance.blockUser(AccessToken: accessToken, To_userId: toID, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                let errorText = sessionError?.errors?["error_text"] as? String
                                self.view.makeToast(errorText ?? "")
                                Logger.error("sessionError = \(errorText ?? "")")
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

