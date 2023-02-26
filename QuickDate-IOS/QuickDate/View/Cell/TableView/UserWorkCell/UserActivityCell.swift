//
//  UserActivityCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserActivityCell: UITableViewCell {

    @IBOutlet var headingCell: UILabel!
    @IBOutlet var textsLabel: UILabel!
    
    var titleText: String? {
        didSet {
            headingCell.text = titleText
        }
    }
    
    var explanation: String? {
        didSet {
            textsLabel.text = explanation
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UserActivityCell: NibReusable {}
