//
//  PeopleILikeCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class PeopleILikeCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var vc:LikedUsersVC?
    var id:Int? = 0
    var indexpath:Int? = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.circleView()
    }
    
    func bind(_ object:[String:Any],index:Int ){
        let id = object["id"] as? Int
        let lastSeen = object["lastseen"] as? Int
        let userData = object["userData"] as? [String:Any]
        let avater = userData?["avater"] as? String
        let firstName = userData?["first_name"] as? String
        let lastName = userData?["last_name"] as? String
        let username = userData?["username"] as? String
        let url = URL(string: avater ?? "")
        self.dateLabel.text = self.vc!.setTimestamp(epochTime: String(lastSeen ?? 0 ))
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if firstName ?? "" == "" && lastName  == "" ?? "" {
            self.usernameLabel.text  = username ?? ""
        }else{
            self.usernameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
        }
        self.id = id ?? 0
        self.indexpath = index
    }
    
    @IBAction func disHeartPressed(_ sender: Any) {
        self.deleteLikeUser()
    }
    
    private func deleteLikeUser(){
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                LikeDislikeMananger.instance.deleteLike(AccessToken: accessToken, id: self.id ?? 0) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc!.dismissProgressDialog {
                                self.vc?.likeUsers.remove(at: self.indexpath ?? 0)
                                self.vc?.collectionView.reloadData()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                self.vc?.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                self.vc?.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                }
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.vc?.view.makeToast(InterNetError)
        }
    }
}
