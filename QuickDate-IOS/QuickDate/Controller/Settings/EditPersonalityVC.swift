

import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditPersonalityVC: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var petTextFIeld: FloatingTextField!
    @IBOutlet weak var friendsTextField: FloatingTextField!
    @IBOutlet weak var childrenTextField: FloatingTextField!
    @IBOutlet weak var characterTextIField: FloatingTextField!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewSave: UIView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let appNavigator: AppNavigator = .shared
    
    var characterStringIndex:String? = ""
    var childrenStringIndex:String? = ""
    var friendsStringIndex:String? = ""
    var petStringIndex:String? = ""
    
    
    var characterShipStatus = false
    var childrenStatus = false
    var friendStatus = false
    var petStatus = false
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updatePersonality()
    }
    
    private func setupUI(){
        if ControlSettings.shouldShowAddMobBanner{
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        
        self.personalInfoLabel.text = "Personality Info".localized
        self.characterTextIField.setTitle(title: "Character".localized)
        self.childrenTextField.setTitle(title: "Children".localized)
        self.friendsTextField.setTitle(title: "Friends".localized)
        self.petTextFIeld.setTitle(title: "Pet".localized)
        self.lblSave.text = "SAVE".localized
        
        let userSettings = appInstance.userProfileSettings
        
        if let character = userSettings?.profile.character.text {
            self.characterTextIField.text = character
        }
        
        if let children = userSettings?.profile.children.text {
            self.childrenTextField.text = children
        }
        
        if let friends = userSettings?.profile.friends.text {
            self.friendsTextField.text = friends
        }
        
        if let pets = userSettings?.profile.pets.text {
            self.petTextFIeld.text = pets
        }
        
        self.characterStringIndex = userSettings?.profile.character.type
        self.childrenStringIndex = userSettings?.profile.children.type
        self.friendsStringIndex = userSettings?.profile.friends.type
        self.petStringIndex = userSettings?.profile.pets.type
        
        self.viewSave.cornerRadiusV = viewSave.bounds.height / 2
        
        self.characterTextIField.delegate = self
        self.childrenTextField.delegate = self
        self.friendsTextField.delegate = self
        self.petTextFIeld.delegate = self
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    @IBAction func onBtnCharacterTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .character))
    }
    
    @IBAction func onBtnChildrenTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .children))
    }
    
    @IBAction func onBtnFriendTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .friends))
    }
    
    @IBAction func onBtnPetTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .pets))
    }
    
    private func updatePersonality(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let pet  = self.petStringIndex ?? ""
            let friend = self.friendsStringIndex ?? ""
            let children = self.childrenStringIndex ?? ""
            let character = self.characterStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editPersonality(AccessToken: accessToken, Character: character, Children: children, Friends: friend, Pet: pet, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
}
extension EditPersonalityVC: DidSetProfilesParamDelegate {
    
    func setProfileParam(status: Bool, selectedString: String, type: ProfileEditType) {
        if type == .character {
            self.characterTextIField.text = selectedString
        } else if type == .children {
            self.childrenTextField.text = selectedString
        } else if type == .friends {
            self.friendsTextField.text = selectedString
        } else if type == .pets {
            self.petTextFIeld.text = selectedString
        }
    }
    
    func setProfileParam(status: Bool, selectedString: String, Type: String, index: Int) {
        if Type == "Character"{
            self.characterTextIField.text = selectedString
            self.characterStringIndex = "\(index)"
        }else if Type == "Children"{
            self.childrenTextField.text = selectedString
            self.childrenStringIndex = "\(index)"
        }else if Type == "Friends"{
            self.friendsTextField.text = selectedString
            self.friendsStringIndex = "\(index)"
        }else if Type == "Pet"{
            self.petTextFIeld.text = selectedString
            self.petStringIndex = "\(index)"
        }
        
    }
    
    
}
