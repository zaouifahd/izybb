

import UIKit
import Async
import QuickDateSDK

class EditProfileVC: BaseViewController,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var genderLAbel: UILabel!
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var relationshipTextFIeld: FloatingTextField!
    @IBOutlet weak var educationTextField: FloatingTextField!
    @IBOutlet weak var workStatusTextIFled: FloatingTextField!
    @IBOutlet weak var languageTextFIeld: FloatingTextField!
    @IBOutlet weak var locationTextField: UITextView!
    @IBOutlet weak var birthdayTextField: FloatingTextField!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var lastNameTextFIeld: FloatingTextField!
    @IBOutlet weak var firstNameTextField: FloatingTextField!
    @IBOutlet var emptyButtonList: [UIButton]!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewSave: UIView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let appNavigator: AppNavigator = .shared
    
    var relationStripStringIndex:String? = ""
    var workStatusStringIndex:String? = ""
    var educationStringIndex:String? = ""
    
    var checkRelationShipStatus = false
    var checkWorkStatus = false
    var checkEducationStatus = false
    private var genderString:String? = ""
     let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.showDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    private func setupUI(){
        emptyButtonList.forEach { $0.setTitle("", for: .normal) }
        
        self.editProfileLabel.text = "Edit Profile Info".localized
        self.genderLAbel.text = "Gender".localized
        self.maleLabel.text = "Male".localized
        self.femaleLabel.text = "Female".localized
        
        self.firstNameTextField.setTitle(title: "First name".localized)
        self.lastNameTextFIeld.setTitle(title: "Last name".localized)
        self.birthdayTextField.setTitle(title: "Birthday".localized)
        self.languageTextFIeld.setTitle(title: "Language".localized)
        self.relationshipTextFIeld.setTitle(title: "Relationship".localized)
        self.workStatusTextIFled.setTitle(title: "Work status".localized)
        self.educationTextField.setTitle(title: "Education".localized)
        self.lblSave.text = "SAVE".localized
        self.viewSave.cornerRadiusV = self.viewSave.bounds.height / 2
        let userSettings =  appInstance.userProfileSettings

        self.firstNameTextField.text = userSettings?.firstName
        self.lastNameTextFIeld.text = userSettings?.lastName
        self.birthdayTextField.text = userSettings?.birthDay
        self.locationTextField.text = userSettings?.location
        self.languageTextFIeld.text = userSettings?.profile.preferredLanguage.text
        
        self.genderString = userSettings?.genderText.capitalized
        if userSettings?.genderText == "Male" {
            self.maleBtn.setImage(.radioONIcon, for: .normal)
        } else {
            self.femaleBtn.setImage(.radioONIcon, for: .normal)
        }
        
        if let relationship = userSettings?.profile.relationShip.text {
            self.relationshipTextFIeld.text = relationship.htmlAttributedString ?? ""
        }
        
        if let workStatus = userSettings?.profile.workStatus.text {
            self.workStatusTextIFled.text = workStatus.htmlAttributedString ?? ""
        }
        
        if let education = userSettings?.profile.education.text {
            self.educationTextField.text = education.htmlAttributedString ?? ""
        }
        self.relationStripStringIndex = userSettings?.profile.relationShip.type
        self.workStatusStringIndex = userSettings?.profile.workStatus.type
        self.educationStringIndex = userSettings?.profile.education.type
        
        self.locationTextField.delegate = self
    }
      func showDatePicker(){
       //Formate Date
        datePicker.datePickerMode = .date
        // ToolBar

       //done button & cancel button
        let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

    // add toolbar to textField
    birthdayTextField.inputAccessoryView = toolbar
     // add datepicker to textField
    birthdayTextField.inputView = datePicker

       }
    @objc func donedatePicker(){
     //For date formate
      let formatter = DateFormatter()
      formatter.dateFormat = "dd/MM/yyyy"
      birthdayTextField.text = formatter.string(from: datePicker.date)
      //dismiss date picker dialog
      self.view.endEditing(true)
       }

    @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .language))
        case 1: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .relationship))
        case 2: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .workStatus))
        case 3: appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .education))
        default: break
        }
    }
      
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.locationTextField.resignFirstResponder()
        let Stroyboard =  UIStoryboard(name: "Settings", bundle: nil)
        let vc = Stroyboard.instantiateViewController(withIdentifier: "MapController") as! MapController
        vc.delegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func malePressed(_ sender: Any) {
        self.maleBtn.setImage(R.image.ic_radioOn(), for: .normal)
        self.femaleBtn.setImage(R.image.ic_radioOff(), for: .normal)
        self.genderString = "Male"
    }
    
    @IBAction func femalePressed(_ sender: Any) {
        self.femaleBtn.setImage(R.image.ic_radioOn(), for: .normal)
        self.maleBtn.setImage(R.image.ic_radioOff(), for: .normal)
        self.genderString = "Female"
    }
    @IBAction func savePressed(_ sender: Any) {
        updateProfile()
    }
    private func updateProfile(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let firstname = self.firstNameTextField.text ?? ""
            let lastname = self.lastNameTextFIeld.text ?? ""
            let genderString = self.genderString ?? ""
            let birthdayString = self.birthdayTextField.text ?? ""
            let location = self.locationTextField.text ?? ""
            let language = self.languageTextFIeld.text ??  ""
            let relationshipStatus = self.relationStripStringIndex ?? ""
            let workStatus = self.workStatusStringIndex ?? ""
            let education = self.educationStringIndex ?? ""
            Async.background({
                ProfileManger.instance.editProfile(AccessToken: accessToken, Firstname: firstname, LastName: lastname, Gender: genderString, Birthday: birthdayString, Location: location, language: language, RelationShip: relationshipStatus, workStatus: workStatus, Education: education, completionBlock: { (success, sessionError, error) in
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
extension EditProfileVC:DidSetProfilesParamDelegate{
    
    func setProfileParam(status: Bool, selectedString: String, type: ProfileEditType) {
        
        
        if type == .language {
            self.languageTextFIeld.text = selectedString
            
        } else if type == .relationship {
            self.relationshipTextFIeld.text = selectedString
            
        } else if type == .workStatus {
            self.workStatusTextIFled.text = selectedString
            
        } else if type == .education {
            self.educationTextField.text = selectedString
            
        }
    }
    
}

extension EditProfileVC:getAddressDelegate{
    func getAddress(address: String) {
        self.locationTextField.text = address
    }
}
