//
//  InviteFriendsSecondTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class InviteFriendsSecondTableItem: UITableViewCell {
    
    @IBOutlet var iconBackgroundView: UIView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
      func configView(row: Int) {
            iconBackgroundView.circleView()
            if row == 1 {
                titleLabel.text = NSLocalizedString("Copy Profile Link", comment: "Copy Profile Link")
                iconBackgroundView.backgroundColor = .Main_StartColor
            } else {
                titleLabel.text = NSLocalizedString("Social Media Invite", comment: "Social Media Invite") 
                iconBackgroundView.backgroundColor = UIColor(red: 29/255, green: 127/255, blue: 229/255, alpha: 1.0)
            }
        }
    }

