//
//  ReceiverImageTableItem.swift
//  DeepSoundiOS
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ReceiverImageTableItem: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var cornerimage: UIImageView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.bgView.backgroundColor = .Main_StartColor
        self.cornerimage.tintColor = .Main_StartColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(_ object:[String:Any]){
        let messageType = object["message_type"] as? String
        let media = object["media"] as? String
        let sticker = object["sticker"] as? String
        if messageType == "media"{
            let thumbnailURL = URL.init(string:media ?? "")
                       self.thumbnailImage.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
        }else{
            let thumbnailURL = URL.init(string:sticker ?? "")
            self.thumbnailImage.sd_setImage(with: thumbnailURL , placeholderImage:R.image.imagePlacholder())
           
        }
      
    }
    
}
