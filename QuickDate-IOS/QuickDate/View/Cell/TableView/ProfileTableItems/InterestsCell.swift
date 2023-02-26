

import UIKit

class InterestsCell: UITableViewCell {

    @IBOutlet var interestsLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet weak var interestTitleLabel: UILabel!
    var vc = profileVC()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.interestTitleLabel.text = NSLocalizedString("Interests", comment: "Interests")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func editButtonAction(_ sender: Any) {
        let interestVC = R.storyboard.popUps.interestPopUpVC()
         interestVC?.delegate = self
        self.vc.present(interestVC!, animated: true, completion: nil)
    }
}

extension InterestsCell:ReloadTableViewDataDelegate{
    func reloadTableView(Status: Bool) {
        if Status{
            self.vc.tableView.reloadData()
        }
    }
}
