//
//  ChatScreenTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ChatScreenTableItem: UITableViewCell {
    
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var textMsgLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var viewMessgaeCount: UIView!
    @IBOutlet weak var viewSetOnlineOffline: UIImageView!
    @IBOutlet weak var lblTotalMsgCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.circleView()
        viewMessgaeCount.circleView()
        viewSetOnlineOffline.circleView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ object:[String:Any]){
        let text = object["text"] as? String
        let user = object["user"] as? [String:Any]
        let firstName = user?["first_name"] as? String
        let lastName = user?["last_name"] as? String
        let username = user?["username"] as? String
        let time = object["time"] as? String
        let avater = user?["avater"] as? String
        let messageType = object["message_type"] as? String
        let newMessages = object["new_messages"] as? Int
        let lastseen = user?["lastseen"] as? String
        if newMessages != 0 {
            viewMessgaeCount.isHidden = false
            lblTotalMsgCount.text = "\(newMessages ?? 0)"
        } else {
            viewMessgaeCount.isHidden = true
        }
        
        let milisecond = lastseen ?? "0"
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)!/1000)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if dateVar == Date() {
            viewSetOnlineOffline.backgroundColor = UIColor.hexStringToUIColor(hex: "47D017")
        } else {
            viewSetOnlineOffline.backgroundColor = UIColor.hexStringToUIColor(hex: "BDBDBD")
        }
        
        print(dateFormatter.string(from: dateVar))
        
        self.textMsgLabel.text  = text ?? ""
        if firstName == "" && lastName  == ""{
            self.userNameLabel.text = username ?? ""
        }else{
            self.userNameLabel.text =  "\(firstName ?? "") \(firstName ?? "")" ?? username ?? ""
        }
        self.timeLabel.text = time ?? ""
        let url = URL(string: avater ?? "")
        self.avatarImageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        
        if messageType == "media"{
            self.textMsgLabel.text = "Photo"
            self.iconImage.isHidden = false
        }else if messageType == "sticker"{
            self.textMsgLabel.text = "sticker"
            self.iconImage.isHidden = false
        }else{
            self.textMsgLabel.text = text ?? ""
            self.iconImage.isHidden = true
            
        }
    }
    
}
