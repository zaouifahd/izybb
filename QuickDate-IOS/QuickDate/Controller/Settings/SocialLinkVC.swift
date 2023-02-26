//
//  SocialLinkVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Toast
import Async
import QuickDateSDK

class SocialLinkVC: BaseViewController {

    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var facebookText: FloatingTextField!
    @IBOutlet var twitterText: FloatingTextField!
    @IBOutlet var googleText: FloatingTextField!
    @IBOutlet var instaText: FloatingTextField!
    @IBOutlet var linkedInText: FloatingTextField!
    @IBOutlet var websiteText: FloatingTextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewSave: UIView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigation(hide: true)
        configView()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    //MARK:- Methods
    func configView() {
    }
    
    private func setupUI(){
        self.socialLabel.text = NSLocalizedString("Social Links", comment: "Social Links")
        
        self.facebookText.setTitle(title: NSLocalizedString("Facebook", comment: "Facebook"))
        self.twitterText.setTitle(title: NSLocalizedString("Twitter", comment: "Twitter"))
        self.googleText.setTitle(title: NSLocalizedString("Google Plus", comment: "Google Plus"))
        self.instaText.setTitle(title: NSLocalizedString("Instagram", comment: "Instagram"))
         self.linkedInText.setTitle(title: NSLocalizedString("LinkedIn", comment: "LinkedIn"))
        self.websiteText.setTitle(title: NSLocalizedString("Website", comment: "Website"))
        
        lblSave.text = NSLocalizedString("SAVE", comment: "SAVE")
        
        self.facebookText.text = appInstance.userProfileSettings?.facebookURL
        self.twitterText.text = appInstance.userProfileSettings?.twitterURL
        self.googleText.text = appInstance.userProfileSettings?.googleURL
        self.instaText.text = appInstance.userProfileSettings?.instagramURL
        self.linkedInText.text = appInstance.userProfileSettings?.linkedinURL
        self.websiteText.text = appInstance.userProfileSettings?.websiteURL
        viewSave.cornerRadiusV = viewSave.bounds.height / 2
        
     }
    private func updateSocialLinks(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let facebook = self.facebookText.text ?? ""
            let twitter = self.twitterText.text ?? ""
            let google = self.googleText.text ?? ""
            let instagram = self.instaText.text ?? ""
            let linkdin = self.linkedInText.text ?? ""
            let website = self.websiteText.text ?? ""
            Async.background({
                ProfileManger.instance.updateSocialLinks(AccessToken: accessToken, facebook: facebook, twitter: twitter, google: google, instagram: instagram, linkedIn: linkdin, website: website, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
//                                AppInstance.shared.fetchUserProfile(view: self.view, completion: {
//                                     Logger.debug("UPDATED")
//                                })
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
    
    
    //MARK:- Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
       updateSocialLinks()
    }
}
