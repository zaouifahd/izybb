

import UIKit

class LifeStyleCell: UITableViewCell {
    @IBOutlet var iLiveWithLabel: UILabel!
    @IBOutlet var carLabel: UILabel!
    @IBOutlet var religionLabel: UILabel!
    @IBOutlet var smokeLabel: UILabel!
    @IBOutlet var drinkLabel: UILabel!
    @IBOutlet var travelLabel: UILabel!
    @IBOutlet weak var travelTitleLabel: UILabel!
    @IBOutlet weak var drinkTitleLabel: UILabel!
    @IBOutlet weak var smokeTitleLabel: UILabel!
    @IBOutlet weak var religionTitleLabel: UILabel!
    @IBOutlet weak var carTitleLabel: UILabel!
    @IBOutlet weak var iLIvewithTitleLabel: UILabel!
    @IBOutlet weak var lifeStyleLabel: UILabel!
    var vc = profileVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lifeStyleLabel.text = NSLocalizedString("Lifestyle", comment: "Lifestyle")
        self.iLIvewithTitleLabel.text = NSLocalizedString("I live with", comment: "I live with")
         self.carTitleLabel.text = NSLocalizedString("Car", comment: "Car")
         self.religionTitleLabel.text = NSLocalizedString("Religion", comment: "Religion")
         self.smokeTitleLabel.text = NSLocalizedString("Smoke", comment: "Smoke")
         self.drinkTitleLabel.text = NSLocalizedString("Drink", comment: "Drink")
        self.travelTitleLabel.text = NSLocalizedString("Travel", comment: "Travel")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editButtonAction(_ sender: Any) {
        let nextVC = R.storyboard.settings.editLifeStyleVC()
        self.vc.navigationController?.pushViewController(nextVC!, animated: true)
        
    }

}
