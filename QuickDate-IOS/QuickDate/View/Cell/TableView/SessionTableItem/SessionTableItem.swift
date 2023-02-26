//
//  SessionTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

class SessionTableItem: UITableViewCell {
    

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var lastSeenlabel: UILabel!
    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    var object : [String:Any]?
    
    var singleCharacter :String?
    var indexPath:Int? = 0
    var vc:SessionsVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func bind(_ object:[String:Any], index:Int){
        self.object = object
        self.indexPath = index
        let os = object["os"] as? String
        let platform = object["platform"] as? String
        let timeText = object["time_text"] as? String
        
        self.phoneLabel.text = "\(NSLocalizedString("Phone", comment: "Phone")) : \(os ?? "")"
        self.browserLabel.text = "\(NSLocalizedString("Browser", comment: "Browser")) : \(platform ?? "")"
        self.phoneLabel.text = "\(NSLocalizedString("Last seen", comment: "Last seen")) : \(timeText ?? "")"
        if platform ?? "" == nil{
            self.alphaLabel.text = self.singleCharacter ?? ""
        }else{
            for (index, value) in (platform?.enumerated())!{
                if index == 0{
                    self.singleCharacter = String(value)
                    break
                }
            }
            self.alphaLabel.text = self.singleCharacter ?? ""
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.deleteSession()
        
    }
    private func deleteSession(){
        let id = self.object?["id"] as? Int
        let accessToken = AppInstance.shared.accessToken ?? ""
        Async.background({
            SessionManager.instance.deleteSession(AccessToken: accessToken, id: id ?? 0) { (success, sessionError, error) in
                if success != nil{
                    Async.main({
                        
                        self.vc?.sessionArray.remove(at: self.indexPath ?? 0)
                        self.vc?.tableView.reloadData()
                        
                        
                    })
                }else if sessionError != nil{
                    Async.main({
                        
                        self.vc!.view.makeToast(sessionError?.message ?? "")
                        Logger.error("sessionError = \(sessionError?.message ?? "")")
                        
                        
                    })
                }else {
                    Async.main({
                        
                        self.vc!.view.makeToast(error?.localizedDescription ?? "")
                        Logger.error("error = \(error?.localizedDescription ?? "")")
                        
                    })
                }
            }
            
            
        })
        
    }
    
}

