

import UIKit

class LooksCell: UITableViewCell {
    @IBOutlet weak var bodyTypeLabel: UILabel!
    
    @IBOutlet weak var hairCOlor: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var ethenicityLabel: UILabel!
    @IBOutlet weak var BodyTypeTitleLabel: UILabel!
    
    @IBOutlet weak var hairColorTitleLabel: UILabel!
    @IBOutlet weak var heightTitleLabel: UILabel!
    @IBOutlet weak var EthnicityTitleLabel: UILabel!
    @IBOutlet weak var looksLabel: UILabel!
    var vc = profileVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.looksLabel.text = NSLocalizedString("Looks", comment: "Looks")
        self.ethenicityLabel.text = NSLocalizedString("Ethnicity", comment: "Ethnicity")
        self.BodyTypeTitleLabel.text = NSLocalizedString("Body Type", comment: "Body Type")
        self.heightTitleLabel.text = NSLocalizedString("Height", comment: "Height")
        self.hairColorTitleLabel.text = NSLocalizedString("Hair Color", comment: "Hair Color")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func editPressed(_ sender: Any) {
        let nextVC = R.storyboard.settings.editLooksVC()
        self.vc.navigationController?.pushViewController(nextVC!, animated: true)
    }
}
