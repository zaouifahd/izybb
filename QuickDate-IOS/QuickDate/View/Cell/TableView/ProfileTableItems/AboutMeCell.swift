

import UIKit

class AboutMeCell: UITableViewCell {

    @IBOutlet var editButton: UIButton!
    @IBOutlet weak var aboutMeLabel: UILabel!

    @IBOutlet weak var aboutTitleLabel: UILabel!
    var vc = profileVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.aboutTitleLabel.text = NSLocalizedString("About Me", comment: "About Me")
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func editButtonAction(_ sender: Any) {
        let aboutVC = R.storyboard.popUps.aboutMePopUpVC()
        aboutVC?.delegate = self
        self.vc.present(aboutVC!, animated: true, completion: nil)
        
    }
}
extension AboutMeCell:ReloadTableViewDataDelegate{
    func reloadTableView(Status: Bool) {
        if Status{
            self.vc.tableView.reloadData()
        }
    }
}
