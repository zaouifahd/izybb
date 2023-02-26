

import UIKit

class BlogsTableCell: UITableViewCell {
    @IBOutlet weak var descriptionlabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryBg: UIView!
    @IBOutlet weak var blogCategoryLabel: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bind(_ object:[String:Any]){
        let title = object["title"] as? String
        let description = object["content"] as? String
        let categoryName = object["category_name"] as? String
        let thumbnail = object["thumbnail"] as? String
        self.titleLabel.text = title ?? ""
        self.timeLabel.text = ""
        self.descriptionlabel.text = description?.htmlAttributedString?.htmlAttributedString
        
        
        self.blogCategoryLabel.text = categoryName ?? ""
        
        if let avatarURL = URL(string: thumbnail ?? "") {
            self.blogImage.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "no_profile_image"))
        } else {
            self.blogImage.image = UIImage(named: "no_profile_image")
        }
    }
    
    
}
