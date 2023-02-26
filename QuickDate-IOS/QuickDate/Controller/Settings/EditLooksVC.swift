
import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditLooksVC: BaseViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var editLooksInfoLabel: UILabel!
    @IBOutlet weak var colorTextField: FloatingTextField!
    @IBOutlet weak var heightTextField: FloatingTextField!
    @IBOutlet weak var bodyTextField: FloatingTextField!
    @IBOutlet weak var ethnicityTextField: FloatingTextField!
    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    var ethnicityStringIndex:String? = ""
    var bodyStringIndex:String? = ""
    var heightStringIndex:String? = ""
    
    var ethnicityStatus = false
    var bodyStatus = false
    var heightStatus = false
    var bannerView: GADBannerView!
    
    // MARK: - Properties
    // Property Injections
    private let appNavigator: AppNavigator = .shared
    private let userSettings = AppInstance.shared.userProfileSettings

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
        updateLooks()
    }
    private func setupUI(){
        if ControlSettings.shouldShowAddMobBanner{

                         bannerView = GADBannerView(adSize: GADAdSizeBanner)
                         addBannerViewToView(bannerView)
                         bannerView.adUnitID = ControlSettings.addUnitId
                         bannerView.rootViewController = self
                         bannerView.load(GADRequest())
                       
                     }
        self.editLooksInfoLabel.text = "Edit looks Info".localized
        self.ethnicityTextField.setTitle(title: "Ethnicity".localized)
        self.bodyTextField.setTitle(title: "Body".localized)
        self.heightTextField.setTitle(title: "Height".localized)
        self.colorTextField.setTitle(title: "Color".localized)
        self.lblSave.text = "SAVE".localized
        self.viewSave.cornerRadiusV = viewSave.bounds.height / 2
        self.colorTextField.text = userSettings?.favourites.colour
        
        if let ethnicity = userSettings?.profile.ethnicity.text {
            self.ethnicityTextField.text = ethnicity
        }
        
        if let body = userSettings?.profile.body.text {
            self.bodyTextField.text = body
        }
        
        
        if let height = userSettings?.profile.height.text {
            self.heightTextField.text = height
        }
        
        self.ethnicityStringIndex = userSettings?.profile.ethnicity.type
        self.bodyStringIndex = userSettings?.profile.body.type
        self.heightStringIndex = userSettings?.profile.height.type
        
        self.ethnicityTextField.delegate = self
        self.bodyTextField.delegate = self
        self.heightTextField.delegate = self
       
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
    
    
    @IBAction func onBtnEthnicityTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .ethnicity))
    }
    
    @IBAction func onBodyTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .body))
    }
    
    @IBAction func onBtnHeightTapped(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .height))
    }
    
    private func updateLooks(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let color = self.colorTextField.text ?? ""
            let height = self.heightStringIndex ?? ""
            let body = self.bodyStringIndex ?? ""
            let ethnicity = self.ethnicityStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editLooks(AccessToken: accessToken, Color: color, Body: body, Height: height, Ethnicity: ethnicity, completionBlock: { (success, sessionError, error) in
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
    // MARK: - textfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
extension EditLooksVC:DidSetProfilesParamDelegate{
    
    func setProfileParam(status: Bool, selectedString: String, type: ProfileEditType) {
        if type == .ethnicity {
            self.ethnicityTextField.text = selectedString
            
        } else if type == .body {
            self.bodyTextField.text = selectedString
            
        } else if type == .height {
            self.heightTextField.text = selectedString
            
        }
    }
    
}
