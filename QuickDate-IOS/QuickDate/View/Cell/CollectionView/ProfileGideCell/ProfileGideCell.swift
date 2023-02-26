//
//  ProfileGideCell.swift
//  QuickDate
//
//  Created by iMac on 10/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class ProfileGideCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var itemIconImage: UIImageView!
    @IBOutlet var labelItemTitle: UILabel!
  //  @IBOutlet var labelItemInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.cornerRadiusV = 20
        viewMain.borderColorV = UIColor().hexStringToUIColor(hex: "ECECEC")
        viewMain.borderWidthV = 1
    }

}
