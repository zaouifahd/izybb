//
//  FriendRequestTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

class FriendRequestTableItem: UITableViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var notifyContentLabel: UILabel!
    @IBOutlet var notifyTypeIcon: UIImageView!
    
    var uid: Int?
    var vc:RequestVC?
    var baseVC:BaseViewController?
    var indexPath:Int? = 0
    
    var notification: AppNotification? {
        didSet {
            guard let notification = notification else { Logger.error("getting user"); return }
            
            notifyTypeIcon.image = .heartFillCustom
            notifyContentLabel.text = "Requested to be a friend with you".localized
            
            avatarImageView.sd_setImage(with: notification.notifierUser.avatarUrl,
                                        placeholderImage: .unisexAvatar)
            
            self.userLabel.text = notification.notifierUser.fullName
            self.uid = notification.notifierUser.userId
        }
    }
    
    var indexPathRow: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImageView.circleView()
        self.notifyTypeIcon.circleView()
          self.notifyTypeIcon.backgroundColor = .Main_StartColor
        self.selectBtn.backgroundColor = .Button_StartColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func bind(_ object:[String:Any],index:Int){
        let type = object["type"] as? String
        let notifier = object["notifier"] as? [String:Any]
        let username = notifier?["username"] as? String
        let avatar = notifier?["avater"] as? String
        let id = notifier?["id"] as? Int
        let firstName = notifier?["first_name"] as? String
        if type == "friend_request"{
            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
            notifyContentLabel.text =  NSLocalizedString("Requested to be a friend with you", comment: "Requested to be a friend with you")
            self.notifyTypeIcon.backgroundColor = .Main_StartColor
        }
        
        if let avatarURL = URL(string: avatar ?? "") {
            avatarImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
        } else {
            avatarImageView.image = UIImage(named: "no_profile_image")
        }
        self.userLabel.text = firstName ?? ""
        self.uid = id ?? 0
        self.indexPath = index
        
    }
    @IBAction func AcceptPressed(_ sender: Any) {
        approveFriend(uid: self.uid ?? 0)
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.disApproveFriend(uid: self.uid ?? 0)
    }
    private func approveFriend(uid:Int){
        
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            FriendManager.instance.approveFriendRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                            self.vc?.requestList.remove(at: self.indexPath ?? 0)
                            self.vc?.tableVIew.reloadData()
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            
                            self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    })
                }else {
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.vc?.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
    private func disApproveFriend(uid:Int){
        
        let accessToken = AppInstance.shared.accessToken ?? ""
        
        Async.background({
            FriendManager.instance.disApproveFriendRequest(AccessToken: accessToken, uid: uid) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            Logger.debug("userList = \(success?.message ?? "")")
                             self.vc?.requestList.remove(at: self.indexPath ?? 0)
                            self.vc?.tableVIew.reloadData()
                        }
                    })
                }else if sessionError != nil{
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            
                            self.vc?.view.makeToast(sessionError?.errors?.errorText ?? "")
                            Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                        }
                    })
                }else {
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.vc?.view.makeToast(error?.localizedDescription ?? "")
                            Logger.error("error = \(error?.localizedDescription ?? "")")
                        }
                    })
                }
            }
        })
    }
    
}

extension FriendRequestTableItem: NibReusable {}
