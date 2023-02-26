

import UIKit

class ProfileInfoCell: UITableViewCell {
    @IBOutlet weak var workStatus: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var relationshipStatus: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var educationLevelTitleLabel: UILabel!
    @IBOutlet weak var workStatusTitleLabel: UILabel!
    @IBOutlet weak var RelationShipTitleLabel: UILabel!
    @IBOutlet weak var preferredLanguagesTitleLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var birthdayTitleLabel: UILabel!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var profileInfoLabel: UILabel!
    var vc = profileVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameTitleLabel.text = NSLocalizedString("Name", comment: "Name")
        self.genderTitleLabel.text = NSLocalizedString("Gender", comment: "Gender")
         self.birthdayTitleLabel.text = NSLocalizedString("Birthday", comment: "Birthday")
            self.locationTitleLabel.text = NSLocalizedString("Location", comment: "Location")
         self.preferredLanguagesTitleLabel.text = NSLocalizedString("Preferred Language", comment: "Preferred Language")
         self.RelationShipTitleLabel.text = NSLocalizedString("Relationship Status", comment: "Relationship Status")
         self.workStatusTitleLabel.text = NSLocalizedString("Work Status", comment: "Work Status")
         self.educationLevelTitleLabel.text = NSLocalizedString("Education Level", comment: "Education Level")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func editButtonAction(_ sender: Any) {
        let nextVC = R.storyboard.settings.editProfileVC()
        self.vc.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
}
