//
//  ListFriendCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class ListFriendCollectionItem: UICollectionViewCell {
    @IBOutlet var unfriendBtn: UIButton!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    var vc = ListFriendsVC()
    var uid:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func unfriendBtn(_ sender: Any) {
        self.friendUnFriend(uid: uid ?? 0)
    }
    
    func bind(_ object:[String:Any]){
        let id = object["id"] as? Int
        let avater = object["avater"] as? String
        let firstName = object["first_name"] as? String
        let lastName = object["last_name"] as? String
        let username = object["username"] as? String
        self.uid = id ?? 0
        
        let url = URL(string: avater ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if firstName ?? "" == "" && lastName  == "" ?? "" {
            self.usernameLabel.text  = username ?? ""
        }else{
            self.usernameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
        }
    }
    private func friendUnFriend(uid:Int){
        if Connectivity.isConnectedToNetwork(){
            self.vc.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let uid1 = String(uid)
            
            Async.background({
                
                AddFriendRequestManager.instance.AddRequest(AccessToken: accessToken, uid:uid1) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                if success?.message == "Request deleted"{
                                    self.unfriendBtn.setTitle("Add Friend", for: .normal)
                                }else{
                                    self.unfriendBtn.setTitle("Remove friend", for: .normal)
                                }
                                self.vc.view.makeToast(success?.message ?? "")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                
                                self.vc.view.makeToast(sessionError?.errors?.errorText ?? "")
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
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
                }
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.vc.view.makeToast(InterNetError)
        }
        
    }
}
