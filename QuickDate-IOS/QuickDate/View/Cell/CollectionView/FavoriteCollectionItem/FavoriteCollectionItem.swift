//
//  FavoriteCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

class FavoriteCollectionItem: UICollectionViewCell {
    
    @IBOutlet var avtImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var unFavButton: UIButton!
    
    var vc:FavoriteVC?
    var id:String? = ""
    var indexPath:Int? = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.unFavButton.setTitle(NSLocalizedString("UnFavorite", comment: "UnFavorite"), for: .normal)
//        unFavButton.setTitleColor(.Button_StartColor, for: .normal)
//        unFavButton.borderColorV = .Button_StartColor
//        self.avtImageView.circleView()
    }
    
    func bind (_ object:[String:Any],index:Int){
        let userData  = object["userData"] as? [String:Any]
        let firstName = userData?["first_name"] as? String
        let lastName = userData?["last_name"] as? String
        let avater = userData?["avater"] as? String
        let username = userData?["username"] as? String
        let id = userData?["id"] as? String
        if firstName ?? "" == "" && lastName  == "" ?? "" {
            self.userNameLabel.text  = username ?? ""
        }else{
            self.userNameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
        }
        let url = URL(string: avater ?? "")
        self.avtImageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        self.id = id ?? ""
        self.indexPath = index
        
    }
    @IBAction func unFavButtonAction(_ sender: Any) {
        self.unFavorite(uid: self.id ?? "")
    }
    private func unFavorite(uid:String){
        if Connectivity.isConnectedToNetwork(){
            self.vc?.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                FavoriteManager.instance.deleteFavorite(AccessToken: accessToken, uid: Int(uid)!) { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc?.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.vc?.favoriteUser.remove(at: self.indexPath ?? 0)
                                self.vc?.collectionView.reloadData()
                                self.vc?.view.makeToast(success?.message ?? "")
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
