
import UIKit

protocol DidSetProfilesParamDelegate: AnyObject {
    func setProfileParam(status: Bool, selectedString: String, type: ProfileEditType)
}

/// - Tag: ProfileEditPopUpVC
class ProfileEditPopUpVC: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    
    var editType: ProfileEditType = .language
    
    var language:GetSettingsModel.DataClass?
    var loadingArray: [String] = []
    var heightKeysArray:[String] = []
    weak var delegate: DidSetProfilesParamDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    private func setupUI(){
        self.tableView.separatorStyle = .none
        self.typeLabel.text = editType.rawValue.capitalized
        self.loadingArray = editType.propertiesArray
        self.heightKeysArray = editType.heightArray
    }
  
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension  ProfileEditPopUpVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return  self.loadingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel!.text = self.loadingArray[indexPath.row].htmlAttributedString ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) { [self] in
            
            self.delegate?.setProfileParam(
                status: true,
                selectedString: loadingArray[indexPath.row].htmlAttributedString ?? "",
                type: editType)
        }
    }
    
}
