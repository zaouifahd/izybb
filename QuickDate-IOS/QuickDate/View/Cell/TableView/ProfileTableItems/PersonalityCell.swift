

import UIKit

class PersonalityCell: UITableViewCell {

    @IBOutlet weak var petTitleLabel: UILabel!
    @IBOutlet weak var friendsTitleLabel: UILabel!
    @IBOutlet weak var childrenTitleLabel: UILabel!
    @IBOutlet weak var characterTitleLabel: UILabel!
    @IBOutlet weak var personalityLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var characterLabel: UILabel!
    @IBOutlet var chidrenLabel: UILabel!
    @IBOutlet var friendsLabel: UILabel!
    @IBOutlet var petLabel: UILabel!

     var vc = profileVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.personalityLabel.text = NSLocalizedString("Personality", comment: "Personality")
 self.characterTitleLabel.text = NSLocalizedString("Character", comment: "Character")
         self.childrenTitleLabel.text = NSLocalizedString("Children", comment: "Children")
        self.friendsTitleLabel.text = NSLocalizedString("Friends", comment: "Friends")
         self.petTitleLabel.text = NSLocalizedString("Pets", comment: "Pets")
    
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editPressed(_ sender: Any) {
        let nextVC = R.storyboard.settings.editPersonalityVC()
        self.vc.navigationController?.pushViewController(nextVC!, animated: true)
    }
}
