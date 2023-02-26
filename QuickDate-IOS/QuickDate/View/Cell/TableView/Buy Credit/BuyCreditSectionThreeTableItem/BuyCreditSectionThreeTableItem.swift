//
//  BuyCreditSectionThreeTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.


import UIKit

class BuyCreditSectionThreeTableItem: UITableViewCell {
    
    @IBOutlet weak var termsAndConditionBtn: UIButton!
    
    @IBOutlet weak var skipLabel: UILabel!
    @IBOutlet weak var skipCreditBtn: UIView!
    var vc:BuyCreditVC?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    private func setupUI(){
     
        termsAndConditionBtn.setTitle(NSLocalizedString("Terms and conditions", comment: "Terms and conditions"), for: .normal)
        self.skipLabel.text = NSLocalizedString("Skip Credit", comment: "Skip Credit")
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.Main_StartColor, UIColor.Main_EndColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.skipCreditBtn.frame.size.width, height: self.skipCreditBtn.frame.size.height)
        self.skipCreditBtn.layer.insertSublayer(gradient, at: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        skipCreditBtn.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
          self.vc?.dismiss(animated: true, completion: nil)
    }
    @IBAction func termsCondition(_ sender: Any) {
               let vc = R.storyboard.settings.helpVC()
                         vc?.checkString = "terms"
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .fullScreen
            self.vc?.present(vc!, animated: true, completion: nil)
        
    }
}
