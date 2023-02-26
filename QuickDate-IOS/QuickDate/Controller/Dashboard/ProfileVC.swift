//
//  ProfileVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit
import QuickDateSDK
import SafariServices

class ProfileVC: BaseViewController {
    
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var backView: UIView!
    var items: [[String : String]] = []
    
    private var isProTest = true
    private var isPageLoaded: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        isPageLoaded = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigation(hide: true)
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            handleGradientColors()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientColors()
    }
    
    override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        handleGradientColors()
    }
    private func goToLiveStream() {
        let controller = LiveStreamViewController.instantiate(fromStoryboardNamed: .live)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
    }
    
    private func setupUI(){
        self.backView.backgroundColor = Theme.primaryEndColor.colour
        self.profileTableView.separatorStyle = .none
        
        
        
        
        let xib = UINib(nibName: "ProfileSectionOneTableItem", bundle: nil)
        self.profileTableView.register(xib, forCellReuseIdentifier: R.reuseIdentifier.profileSectionOneTableItem.identifier)
        
        let ProfileSectionTwoTableItem = UINib(nibName: "profileSectionTwoTableItem", bundle: nil)
        self.profileTableView.register(ProfileSectionTwoTableItem, forCellReuseIdentifier: R.reuseIdentifier.profileSectionTwoTableItem.identifier)
        
        profileTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        items = createItemList()
        profileTableView.reloadData()
    }
    
    private func handleGradientColors() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    private func didSelectSection(_ indexPath: IndexPath) {
        let isPro = self.isProTest
        
            let row = isPro ? 1 : 0
            if isPro && indexPath.row == 0 {
                goToLiveStream()
            } else if indexPath.row == row { // favourite users
                let vc = R.storyboard.settings.listFriendsVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == row + 1 { // invite friends
                let vc = R.storyboard.settings.likedUsersVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == row + 2 {
                let vc = R.storyboard.settings.dislikeUsersVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == row + 3 {
                let vc = R.storyboard.settings.favoriteVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == row + 4 {
                let vc = R.storyboard.blogs.blogsVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == row + 5 {
                let vc = R.storyboard.settings.inviteFriendsVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else if indexPath.row == row + 6{
                if let url = URL(string: ControlSettings.help_app) {//"\(API.justURL)/contact") {
                    self.present(SFSafariViewController(url: url), animated: true)
                }
            }
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : 1//items.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileSectionOneTableItem.identifier, for: indexPath) as! ProfileSectionOneTableItem
            cell.vc = self
       
            cell.configData()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.profileSectionTwoTableItem.identifier, for: indexPath) as! profileSectionTwoTableItem
            cell.items = items
            cell.reloadCollectionView()
            cell.onDidSelect = { [weak self] (index) in
                guard let self = self else { return }
                self.didSelectSection(index)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 400 : indexPath.section == 1 ? 420 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isPro = self.isProTest
        
        if indexPath.section == 1{
            let row = isPro ? 1 : 0
            if isPro && indexPath.row == 0 {
                goToLiveStream()
            } else if indexPath.row == row { // favourite users
                let vc = R.storyboard.settings.listFriendsVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == row + 1 { // invite friends
                let vc = R.storyboard.settings.likedUsersVC()
                navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == row + 2 {
                let vc = R.storyboard.settings.dislikeUsersVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == row + 3 {
                let vc = R.storyboard.settings.favoriteVC()
                navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == row + 4 {
                let vc = R.storyboard.blogs.blogsVC()
                self.navigationController?.pushViewController(vc!, animated: true)
            } else if indexPath.row == row + 5 {
                let vc = R.storyboard.settings.inviteFriendsVC()
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else if indexPath.row == row + 6{
                if let url = URL(string: "\(API.justURL)/contact") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

extension ProfileVC {
    
    private func createItemList() -> [[String : String]] {
        var dictArray: [[String : String]] = isProTest
        ? [
            [
                "icon": "ic_video_f",
                "title": "Live".localized,
                "info": "Start your own live stream now".localized
            ]
        ]
        : []
        
        let otherDict = [
            [
                "icon": "ic_friends_f",
                "title": NSLocalizedString("Friends", comment: "Friends"),
                "info": "Display all your friend users".localized
            ],
            
            [
                "icon": "ic_like_f",
                "title": NSLocalizedString("People i Liked", comment: "People i Liked"),
                "info": "Display Users i give them a like".localized
            ],
            
            [
                "icon": "ic_dislike_f",
                "title": "People I Disliked".localized,
                "info": "Display users i didn't like".localized
            ],
            
            [
                "icon": "ic_fav_f",
                "title": NSLocalizedString("Favorite", comment: "Favorite"),
                "info": "Display all your favorite users".localized
            ],
            
            [
                "icon": "ic_blog_f",
                "title": NSLocalizedString("Blogs", comment: "Blogs"),
                "info":  "Read the latest Articles".localized
            ],
            
            [
                "icon": "ic_add_f",
                "title": NSLocalizedString("Invite Friends", comment: "Invite Friends"),
                "info": "Invite Friends to the app".localized
            ],
            
            [
                "icon": "ic_faq_f",
                "title": "Need Help?",
                "info": "FAQ, contact us, privacy".localized
            ]
        ]
        
        dictArray.append(contentsOf: otherDict)
        return dictArray
    }
}
