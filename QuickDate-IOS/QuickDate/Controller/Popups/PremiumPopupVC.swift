//
//  PremiumPopupVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class PremiumPopupVC: UIViewController {
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    
    private func setupUI(){
        
        self.topLabel.text = NSLocalizedString("You are Premium User", comment: "You are Premium User")
         self.expirationDateLabel.text = NSLocalizedString("Lifetime", comment: "Lifetime")
        self.skipBtn.setTitle(NSLocalizedString("Skip", comment: "Skip"), for: .normal)
        
    }
    override func viewDidLayoutSubviews() {
        bgView.setGradientBackground(startColor: UIColor.Main_StartColor, endColor: UIColor.Main_EndColor, direction: .horizontal)
      }
    
    private func getDate(unixdate: Int, timezone: String) -> String {
        if unixdate == 0 {return ""}
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixdate))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, MMM d, yyyy"
        dayTimePeriodFormatter.timeZone = .current
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return "Updated: \(dateString)"
    }
    
    
    @IBAction func skipPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
