//
//  SettingsVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK
import SafariServices

class SettingsVC: BaseViewController {
    
    //@IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet var settingsTableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var switchOnOffActiveProfile: UISwitch!
    
    // MARK: - Properties
    private let appManager: AppManager = .shared
    private let userSettings = AppInstance.shared.userProfileSettings
    private var switchStatus:Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideNavigation(hide: true)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
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
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
        // createMainViewGradientLayer(to: upperPrimaryView,
        //                startColor: startColor,
        //          endColor: endColor)
    }
    
    private func onUpdateProfileData() {
        imageViewProfile.circleView()
        let url = URL(string: userSettings?.avatar ?? "")
        imageViewProfile.sd_setImage(with: url, placeholderImage: R.image.no_profile_image())
        lblTitle.text = userSettings?.username ?? ""
    }
    
    deinit {
        Logger.debug("deinit was worked")
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSwitchUserActive(_ sender: Any) {
        if switchOnOffActiveProfile.isOn{
            self.switchStatus = 1
            self.updateOnlineStatus(status:self.switchStatus ?? 0 , switch: switchOnOffActiveProfile)
        }else{
            self.switchStatus = 0
            self.updateOnlineStatus(status:self.switchStatus ?? 0 , switch: switchOnOffActiveProfile)
        }
    }
    
    @IBAction func onBtnLogOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout".localized,
                                      message: "Are you sure you want to logout?".localized,
                                      preferredStyle: .alert)
        
        let comfirm = UIAlertAction(title: "Confirm".localized, style: .default) { (action) in
            self.logoutUser()
            
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
        alert.addAction(comfirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupUI(){
        self.settingsLabel.text = NSLocalizedString("Settings", comment: "Settings")
        self.settingsTableView.separatorStyle = .none
//        self.settingsTableView.register(R.nib.settingsSectionTableItem(), forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier)
//
//
        
        
        let settingsSectionTableItem = UINib(nibName: "SettingsSectionTableItem", bundle: nil)
        self.settingsTableView.register(settingsSectionTableItem, forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier)
        
        let SettingsSectionTwoTableItem = UINib(nibName: "SettingsSectionTwoTableItem", bundle: nil)
        self.settingsTableView.register(SettingsSectionTwoTableItem, forCellReuseIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier)
     
        let SettingsSectionThreeTableItem = UINib(nibName: "SettingsSectionThreeTableItem", bundle: nil)
        self.settingsTableView.register(SettingsSectionThreeTableItem, forCellReuseIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier)
        
        self.onUpdateProfileData()
    }
    private func logoutUser(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                UserManager.instance.logout(AccessToken: accessToken, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                UserDefaults.standard.removeObject(forKey: Local.USER_SESSION.User_Session)
                                
                                let defaults: Defaults = .shared
                                defaults.set(false, for: .didLogUserIn)
                                defaults.clear(.accessToken)
                                defaults.clear(.userID)
                                defaults.clear(.dashboardFilter)
                                defaults.clear(.trendingFilter)
                                defaults.clear(.hotOrNotFilter)
                                
                                let appNavigator: AppNavigator = .shared
                                appNavigator.start(from: .authentication)
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.errors?.errorText ?? "")
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
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
    func removeCache() {
        let caches = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let appId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        let path = String(format:"%@/%@/Cache.db-wal",caches, appId)
        do {
            try FileManager.default.removeItem(atPath: path)
            self.view.makeToast("Cache Cleared")
        } catch {
            print("ERROR DESCRIPTION: \(error)")
        }
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath == IndexPath(row: 1, section: 0) {
            return 56
        } else if indexPath == IndexPath(row: 0, section: 1) {
            return 56//95
        } else if indexPath.section == 4{
            return 56//UITableView.automaticDimension
        } else if indexPath.section == 2 {
            return 56
        }else if indexPath.section == 3 {
            // TODO: change after custom mode is completed
            // Now app dark mode works only according to system settings
            return 0
        }
        else if indexPath.section == 6 {
            return UITableView.automaticDimension
        }
        else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 { // my account
                let vc = R.storyboard.settings.myAccountVC()
                navigationController?.pushViewController(vc!, animated: true)
            }  else if indexPath.row == 1 { // social links
                let vc = R.storyboard.settings.socialLinkVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 2 {
                let vc = R.storyboard.settings.blockUserVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
            else if indexPath.row == 3 { // change password
                let vc = R.storyboard.settings.myAffliatesVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let vc = R.storyboard.settings.withdrawalsVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == 1 {
                let viewController = TransactionsListViewController.instantiate(fromStoryboardNamed: .settings)
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else if indexPath.section == 2{
            if indexPath.row == 0{ // change password
                let vc = R.storyboard.settings.changePasswordVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else   if indexPath.row == 1{ // change password
                let vc = R.storyboard.settings.twoFactorUpdateVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
            else   if indexPath.row == 2{ // change password
                let vc = R.storyboard.settings.sessionsVC()
                navigationController?.pushViewController(vc!, animated: true)
            }
        }else if indexPath.section == 5{
            removeCache()
        }else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                //                let vc = R.storyboard.settings.helpVC()
                //                vc?.checkString = "help"
                //                self.navigationController?.pushViewController(vc!, animated: true)
                guard let url = URL(string: ControlSettings.help_app) else { return }
                self.present(SFSafariViewController(url: url), animated: true)
            case 1:
                //                let vc = R.storyboard.settings.helpVC()
                //                vc?.checkString = "about"
                //                self.navigationController?.pushViewController(vc!, animated: true)
                
                guard let url = URL(string: ControlSettings.aboutUS) else { return }
                self.present(SFSafariViewController(url: url), animated: true)
            case 2: // delete account
                let vc = R.storyboard.settings.deleteAccountVC()
                navigationController?.pushViewController(vc!, animated: true)
            case 3: // logout
                let alert = UIAlertController(title: "Logout".localized,
                                              message: "Are you sure you want to logout?".localized,
                                              preferredStyle: .alert)
                
                let comfirm = UIAlertAction(title: "Confirm".localized, style: .default) { (action) in
                    self.logoutUser()
                    
                }
                let cancel = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
                alert.addAction(comfirm)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
            view.backgroundColor = .clear
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.size.width, height: 45))
            label.setTheme(font: .regularText(size: 17))
            label.textColor = .label
            label.text = NSLocalizedString("General", comment: "General")
            view.addSubview(label)
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 45))
            view.backgroundColor = .clear
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.size.width, height: 45))
            label.setTheme(font: .regularText(size: 17))
            label.textColor = .label
            if section == 0 {
                label.text = NSLocalizedString("General", comment: "General")
            } else if section == 2 {
                label.text = NSLocalizedString("Security", comment: "Security")
            }
            else if section == 3 {
                label.text = NSLocalizedString("", comment: "")//("Display", comment: "Display")
            }
            else if section == 1{
                label.text = NSLocalizedString("Payment", comment: "Payment")
            } else if section == 4 {
                label.text = NSLocalizedString("Support", comment: "Support")
            } else if section == 5 {
                label.text =  NSLocalizedString("Storage", comment: "Storage")
            } else {
                label.text = NSLocalizedString("Privacy", comment: "Privacy")
            }
            if !(label.text ?? "").isEmpty {
                view.addSubview(label)
            }
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        else if section == 2 {
            return 45
        }
        else if section == 3 {
            // TODO: change after custom mode is completed
            // Now app dark mode works only according to system settings
            return 0
        } else {
            return 45
        }
    }
}

extension SettingsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 4
        case 1: return 2//1
        case 2: return 3
        case 3: return 1
        case 4: return 3
        case 5: return 1
        case 6: return 3
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("My Account", comment: "My Account")
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Social Links", comment: "Social Links")
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Blocked Users", comment: "Blocked Users")
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Withdrawals", comment: "Withdrawals")
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("My Affliates", comment: "My Affliates")
                return cell
            default:
                return UITableViewCell()
            }
        case 2:
            switch indexPath.row {
            case 0:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTwoTableItem.identifier) as! SettingsSectionTwoTableItem
                cell.titleLabel.text = NSLocalizedString("Password", comment: "Password")
                //cell.subTitleLabel.text = NSLocalizedString("Change your password", comment: "Change your password")
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Two-factor Authentication", comment: "Two-factor Authentication")
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
                cell.titleLabel.text = NSLocalizedString("Manage Sessions", comment: "Manage Sessions")
                return cell
            default:
                return UITableViewCell()
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            cell.checkStringStatus = "DarkMode"
            cell.titleLabel.text =  NSLocalizedString("Theme", comment: "Theme")
            
            cell.config()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Withdrawals", comment: "Withdrawals")
                return cell
            case 1:
                cell.titleLabel.text = NSLocalizedString("Transactions", comment: "Transactions")
                return cell
            default:
                return UITableViewCell()
            }
            
            //            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            //            cell.titleLabel.text =  NSLocalizedString("Show when you're active", comment: "Show when you're active")
            //            cell.checkStringStatus = "onlineSwitch"
            //            cell.switchDelegate = self
            //            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionThreeTableItem.identifier) as! SettingsSectionThreeTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Show my profile on search engines?", comment: "Show my profile on search engines?")
                //                if AppInstance.shared.userProfile["privacy_show_profile_on_google"] as? String ?? ""  == "0"{
                if !(userSettings?.showProfileOnGoogle ?? false) {
                    cell.switcher.setOn(false, animated: true)
                    cell.switchStatusValue = false
                }else{
                    cell.switcher.setOn(true, animated: true)
                    cell.switchStatusValue = true
                }
                cell.checkStringStatus = "searchEngine"
                cell.delegate = self
                cell.randomUser = userSettings?.showProfileToRandomUsers
                cell.matchProfile = userSettings?.showProfileToMatchProfiles
                cell.searchEngine = userSettings?.showProfileOnGoogle
                
                //
            case 1:
                cell.titleLabel.text = NSLocalizedString("Show my profile in random users?", comment: "Show my profile in random users?")
                if !(userSettings?.showProfileToRandomUsers ?? false) {
                    cell.switcher.setOn(false, animated: true)
                    cell.switchStatusValue = false
                }else{
                    cell.switcher.setOn(true, animated: true)
                    cell.switchStatusValue = true
                }
                cell.checkStringStatus = "randomUser"
                cell.delegate = self
                cell.randomUser = userSettings?.showProfileToRandomUsers
                cell.matchProfile = userSettings?.showProfileToMatchProfiles
                cell.searchEngine = userSettings?.showProfileOnGoogle
                
            case 2:
                cell.titleLabel.text =  NSLocalizedString("Show my profile in find match page?", comment: "Show my profile in find match page?")
                if !(userSettings?.showProfileToMatchProfiles ?? false) {
                    cell.switcher.setOn(false, animated: true)
                    cell.switchStatusValue = false
                }else{
                    cell.switcher.setOn(true, animated: true)
                    cell.switchStatusValue = true
                }
                cell.checkStringStatus = "matchProfile"
                cell.delegate = self
                cell.randomUser = userSettings?.showProfileToRandomUsers
                cell.matchProfile = userSettings?.showProfileToMatchProfiles
                cell.searchEngine = userSettings?.showProfileOnGoogle
                
            default:
                break
            }
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            cell.titleLabel.text = NSLocalizedString("Clear Cache", comment: "Clear Cache")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.settingsSectionTableItem.identifier) as! SettingsSectionTableItem
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = NSLocalizedString("Help", comment: "Help")
            case 1:
                cell.titleLabel.text = NSLocalizedString("About", comment: "About")
            case 2:
                cell.titleLabel.text = NSLocalizedString("Delete account", comment: "Delete account")
                // case 3:
                //  cell.titleLabel.text = NSLocalizedString("Logout", comment: "Logout")
            default:
                break
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
extension SettingsVC:didUpdateSettingsDelegate{
    func updateSettings(searchEngine: Int, randomUser: Int, matchProfile: Int, switch: UISwitch) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                ProfileManger.instance.updateSettings(AccessToken: accessToken, searchEngine: searchEngine, randomUser: randomUser, matchPage: matchProfile, activeness: 1, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                self.appManager.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
                
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
extension SettingsVC:didUpdateOnlineStatusDelegate{
    func updateOnlineStatus(status: Int, switch: UISwitch) {
        if Connectivity.isConnectedToNetwork(){
            let accessToken = AppInstance.shared.accessToken ?? ""
            Async.background({
                OnlineSwitchManager.instance.getNotifications(AccessToken: accessToken, status: status, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.view.makeToast(success?.message ?? "")
                                self.appManager.fetchUserProfile()
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                                self.view.makeToast(sessionError?.message ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
                
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
    }
}
