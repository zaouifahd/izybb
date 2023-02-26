//
//  BlockUserTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class BlockUserTableItem: UITableViewCell {
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configView() {
        avatarImage.circleView()
    }
//    func bind2(_ object:[String:Any]){
//        let data = object["data"] as? [String:Any]
//        let username = data?["username"] as? String ?? ""
//        let firstName = data?["first_name"] as? String
//        let lastName = data?["last_name"] as? String
//        if firstName ?? "" == "" && lastName  == "" ?? "" {
//            self.userNameLabel.text  = username ?? ""
//        }else{
//            self.userNameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
//        }
//        let url = URL(string: data?["avater"] as? String ?? "")
//        self.avatarImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
//    }
    
    func bind(_ object: Relation) {
        let username = object.username
        let firstName = object.firstName
        let lastName = object.lastName
        if firstName == "" && lastName  == "" {
            self.userNameLabel.text  = username
        }else{
            self.userNameLabel.text = "\(firstName ) \(lastName )"
        }
        let url = URL(string: object.avatarURL)
        self.avatarImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}
