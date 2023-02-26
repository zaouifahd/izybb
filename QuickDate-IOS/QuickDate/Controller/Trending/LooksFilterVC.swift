
import UIKit
import XLPagerTabStrip
class LooksFilterVC: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var toHeightTextFIeld: FloatingTextField!
    @IBOutlet weak var fromHeightTextFIeld: FloatingTextField!
    @IBOutlet weak var bodyTextField: FloatingTextField!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var viewFromHeight: UIView!
    @IBOutlet weak var viewToHeight: UIView!
    
    // MARK: - Properties
    private let appNavigator: AppNavigator = .shared
    private let appInstance: AppInstance = .shared
    
    private var filters = Defaults.shared.get(for: .trendingFilter) ?? TrendingFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetFilter()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.hideTabBar()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    private func resetFilter() {
        AppManager.shared.onResetFilter = { [weak self] () -> Void in
            guard let self = self else { return }
            self.toHeightTextFIeld.text = ""
            self.fromHeightTextFIeld.text = ""
            self.bodyTextField.text = ""
        }
    }
    
    private func setupUI() {
        toHeightTextFIeld.setTitle(title: "Looks", isMandatory: false)
        fromHeightTextFIeld.setTitle(title: "Height To", isMandatory: false)
        bodyTextField.setTitle(title: "Height", isMandatory: false)
        
        viewBody.cornerRadiusV = viewBody.frame.height / 2
        viewBody.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewBody.borderWidthV = 1
        
        viewFromHeight.cornerRadiusV = viewFromHeight.frame.height / 2
        viewFromHeight.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewFromHeight.borderWidthV = 1
        
        viewToHeight.cornerRadiusV = viewToHeight.frame.height / 2
        viewToHeight.borderColorV =  #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        viewToHeight.borderWidthV = 1
        
        let filters = appInstance.trendingFilters
        switch filters.looks.body {
        case .some(let body): self.bodyTextField.text = body.capitalized
        case .none:           self.bodyTextField.placeholder = "Body".localized
        }
        self.fromHeightTextFIeld.text = filters.looks.fromHeight
        self.toHeightTextFIeld.text = filters.looks.toHeight
    }
    
    @IBAction func toHeightPressed(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .toHeight))
    }
    
    @IBAction func fromHeight(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .fromHeight))
    }
    
    @IBAction func bodyPressed(_ sender: Any) {
        appNavigator.popUpNavigate(to: .profileEdit(delegate: self, type: .body))
    }
    
    // MARK: - textfield delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension LooksFilterVC: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "LOOKS".localized)
    }
}

extension LooksFilterVC: DidSetProfilesParamDelegate {
    
    func setProfileParam(status: Bool, selectedString: String, type: ProfileEditType) {
        if type == .body {
            self.bodyTextField.text = selectedString.capitalized
            appInstance.trendingFilters.looks.body = selectedString
        } else if type == .fromHeight {
            self.fromHeightTextFIeld.text = selectedString
            appInstance.trendingFilters.looks.fromHeight = selectedString
        } else if type == .toHeight {
            self.toHeightTextFIeld.text = selectedString
            appInstance.trendingFilters.looks.toHeight = selectedString
        }
    }
    
}
