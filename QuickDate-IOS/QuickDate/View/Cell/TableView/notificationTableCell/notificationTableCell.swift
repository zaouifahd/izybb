//
//  notificationTableCell.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage

class notificationTableCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var notifyContentLabel: UILabel!
    @IBOutlet var notifyTypeIcon: UIImageView!
    
    var notification: AppNotification? {
        didSet {
            guard let notification = notification else { Logger.error("getting user"); return }
            
         //   self.notifyTypeIcon.backgroundColor = .Main_StartColor
            //let image: UIImage? = notification.type == .visit ? .eyeFillCustom : .heartFillCustom
          //  notifyTypeIcon.image = image
            // notificationLabel
            let type = notification.type
            let text: String =
            type == .gotNewMatch ? "You got a new match, click to view!".localized :
            type == .visit ? "Visit you" .localized :
            type == .like ? "Like you" .localized :
            type == .dislike ? "Dislike you" .localized :
            type == .friendAccept ? "Is now in your friend list" .localized
            : "Requested to be a friend with you" .localized
            notifyContentLabel.text = text
            
            avatarImageView.sd_setImage(with: notification.notifierUser.avatarUrl,
                                        placeholderImage: .unisexAvatar)
            
            self.userLabel.text = notification.notifierUser.fullName
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.notifyTypeIcon.circleView()
        self.notifyTypeIcon.backgroundColor = .Main_StartColor
    }
    
    override func draw(_ rect: CGRect) {
        self.avatarImageView.circleView()

    }
    
//    func bind(_ object:[String:Any]){
//        let type = object["type"] as? String
//        let notifier = object["notifier"] as? [String:Any]
//        let username = notifier?["username"] as? String
//        let avatar = notifier?["avater"] as? String
//
//        if type == "got_new_match"{
//            self.notifyTypeIcon.backgroundColor = .Main_StartColor
//            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
//            notifyContentLabel.text = NSLocalizedString("You got a new match, click to view!", comment: "You got a new match, click to view!")
//        }else if type == "visit"{
//            notifyTypeIcon.image = UIImage(named: "small_visits_ic")
//            notifyContentLabel.text = NSLocalizedString("Visit you", comment: "Visit you")
//
//            self.notifyTypeIcon.backgroundColor = .Main_StartColor
//
//        }else if type == "like"{
//            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
//            notifyContentLabel.text = NSLocalizedString("Like you", comment: "Like you")
//           self.notifyTypeIcon.backgroundColor = .Main_StartColor
//        }else if type == "dislike"{
//            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
//            notifyContentLabel.text = NSLocalizedString("Dislike you", comment: "Dislike you")
//            self.notifyTypeIcon.backgroundColor = .Main_StartColor
//        }else if type == "friend_request_accepted"{
//            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
//            notifyContentLabel.text = NSLocalizedString("Is now in your friend list", comment: "Is now in your friend list")
//           self.notifyTypeIcon.backgroundColor = .Main_StartColor
//        }else if type == "friend_request"{
//            notifyTypeIcon.image = UIImage(named: "small_matches_ic")
//            notifyContentLabel.text = NSLocalizedString("Requested to be a friend with you", comment: "Requested to be a friend with you")
//          self.notifyTypeIcon.backgroundColor = .Main_StartColor
//        }
//
//        if let avatarURL = URL(string: avatar ?? "") {
//            avatarImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
//        } else {
//            avatarImageView.image = UIImage(named: "no_profile_image")
//        }
//        self.userLabel.text = username ?? ""
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

extension notificationTableCell: NibReusable {}
