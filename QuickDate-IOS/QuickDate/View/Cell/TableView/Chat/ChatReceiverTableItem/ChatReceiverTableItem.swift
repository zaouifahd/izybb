//
//  ChatReceiverTableItem.swift
//  DeepSoundiOS
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ChatReceiverTableItem: UITableViewCell {
    
    @IBOutlet weak var cornerImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = UIColor.hexStringToUIColor(hex: "BF00FF")
        self.cornerImage.tintColor = .Main_StartColor
        cornerImage.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        self.bgView.setRoundCornersBY(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner,.layerMinXMinYCorner], cornerRaduis: 12)
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    func bind(_ object:[String:Any]){
        let text = object["text"] as? String
        let seen = object["created_at"] as? Int
        self.titleLabel.text = text ?? ""
        self.dateLabel.text = self.getDate(unixdate: seen ?? 0, timezone: "GMT")
    }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "h:mm a"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "\(dateString)"
    }
}
