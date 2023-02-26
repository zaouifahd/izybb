

import UIKit

class ProfileCompletedPercentsCell: UITableViewCell {

    @IBOutlet weak var profleCompleted: UILabel!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var percentProgressView: UIProgressView!
    
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profleCompleted.text = NSLocalizedString("Profile Completed", comment: "Profile Completed")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
