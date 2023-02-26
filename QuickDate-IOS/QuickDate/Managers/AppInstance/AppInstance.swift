
import Foundation
import UIKit
import QuickDateSDK

class AppInstance {
    
    // MARK: - Properties
    static let shared = AppInstance()
    
    // MARK: User Settings
    var userId: Int?
    var accessToken: String?
    
//    var adminSettings: GetSettingsModel.DataClass?
    var adminAllSettings: GetSettingsModel.GetSettingsSuccessModel?
    var adminSettings: AdminAppSettings?
    var userProfileSettings: UserProfileSettings?
    
    var trendingFilters: TrendingFilter = TrendingFilter()
    
    var addCount: Int = 0
    var location: String?
    var gender: String?
    var ageMin: Int?
    var ageMax: Int?
    var body: Int?
    var fromHeight: Int?
    var toHeight: Int?
    var language: Int?
    var religion: Int?
    var ethnicity: Int?
    var relationship: Int?
    var smoke: Int?
    var drink: Int?
    var interest: String?
    var education: Int?
    var pets: Int?
    var distance: Int?
    var isOnline: Bool?
    
    // MARK: - Initialiser
    
    private init() {}
    
    func isConnectedToNetwork(in view: UIView?) -> Bool {
        guard Connectivity.isConnectedToNetwork() else {
            view?.makeToast(InterNetError); return false
        }
        return true
    }
    
}
