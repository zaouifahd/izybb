//
//  profileVC.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class profileVC: BaseViewController {
    
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    private let appInstance: AppInstance = .shared
    private let userSettings = AppInstance.shared.userProfileSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
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
//        createMainViewGradientLayer(to: upperPrimaryView,
//                                    startColor: startColor,
//                                    endColor: endColor)
    }
    
    // MARK: - Private Functions
    
    private func getMediaFiles() -> [MediaFile] {
        guard let userSettings = appInstance.userProfileSettings else {
            Logger.error("getting user settings"); return []
        }
        return userSettings.mediaFiles
    }
    
    // MARK: - Actions
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    private func setupUI(){
        self.myProfileLabel.text = NSLocalizedString("My Profile", comment: "My Profile")
        
    }
}

extension profileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 320
        case 1:
            return 80
        case 2:
            return 80
        case 3:
            return 288
        case 4:
            return 80
        case 5:
            return 176
        case 6:
            return 187
        case 7:
            return 249
        case 8:
            return 368
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImagesCellID", for: indexPath) as! ProfileImagesCell
            cell.selectionStyle = .none
            cell.vc = self
//            let object = AppInstance.shared.userProfile
//            let mediaFiles = object["mediafiles"] as? [[String:Any]]
            let mediaFiles = getMediaFiles()
            
            if (mediaFiles.isEmpty) {
                cell.imageView1.image = R.image.thumbnail()
                cell.imageView2.image = R.image.thumbnail()
                cell.imageView3.image = R.image.thumbnail()
                cell.imageView4.image = R.image.thumbnail()
                cell.imageView5.image = R.image.thumbnail()
                cell.imageView6.image = R.image.thumbnail()
                
            }else{
                // FIXME: Re-write these codes below to provide clean code
                if mediaFiles.count == 1{
//                    let url1 = URL(string: mediaFiles?[0]["avater"] as? String ?? "")
                    let url1 = URL(string: mediaFiles[0].avatar)

                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    
                    
                }else if mediaFiles.count == 2{
                    let url1 = URL(string: mediaFiles[0].avatar)
                    let url2 = URL(string: mediaFiles[1].avatar)
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    
                    
                }else if mediaFiles.count == 3 {
                    let url1 = URL(string: mediaFiles[0].avatar)
                    let url2 = URL(string: mediaFiles[1].avatar)
                    let url3 = URL(string: mediaFiles[2].avatar)
                    
                    
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    
                    
                    
                }else if mediaFiles.count == 4{
                    let url1 = URL(string: mediaFiles[0].avatar)
                    let url2 = URL(string: mediaFiles[1].avatar)
                    let url3 = URL(string: mediaFiles[2].avatar)
                    let url4 = URL(string: mediaFiles[3].avatar)
                    
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    
                    
                }else if mediaFiles.count == 5{
                    let url1 = URL(string: mediaFiles[0].avatar)
                    let url2 = URL(string: mediaFiles[1].avatar)
                    let url3 = URL(string: mediaFiles[2].avatar)
                    let url4 = URL(string: mediaFiles[3].avatar)
                    let url5 = URL(string: mediaFiles[4].avatar)
                    
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    cell.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                    
                    
                }else if mediaFiles.count == 6{
                    let url1 = URL(string: mediaFiles[0].avatar)
                    let url2 = URL(string: mediaFiles[1].avatar)
                    let url3 = URL(string: mediaFiles[2].avatar)
                    let url4 = URL(string: mediaFiles[3].avatar)
                    let url5 = URL(string: mediaFiles[4].avatar)
                    let url6 = URL(string: mediaFiles[5].avatar)
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    cell.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                    cell.imageView6.sd_setImage(with: url6, placeholderImage: R.image.thumbnail())
                    
                }else{
                    let url1 = URL(string: mediaFiles[0].avatar)
                    let url2 = URL(string: mediaFiles[1].avatar)
                    let url3 = URL(string: mediaFiles[2].avatar)
                    let url4 = URL(string: mediaFiles[3].avatar)
                    let url5 = URL(string: mediaFiles[4].avatar)
                    let url6 = URL(string: mediaFiles[5].avatar)
                    cell.imageView1.sd_setImage(with: url1, placeholderImage: R.image.thumbnail())
                    cell.imageView2.sd_setImage(with: url2, placeholderImage: R.image.thumbnail())
                    cell.imageView3.sd_setImage(with: url3, placeholderImage: R.image.thumbnail())
                    cell.imageView4.sd_setImage(with: url4, placeholderImage: R.image.thumbnail())
                    cell.imageView5.sd_setImage(with: url5, placeholderImage: R.image.thumbnail())
                    cell.imageView6.sd_setImage(with: url6, placeholderImage: R.image.thumbnail())
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCompletedPercentsCellID", for: indexPath) as! ProfileCompletedPercentsCell
            cell.selectionStyle = .none

            let value = Double(appInstance.userProfileSettings?.profileCompletion ?? 0)
            cell.percentProgressView.progress = Float(userSettings?.profileCompletion ?? 0)/100.0
            cell.percentLabel.text = "\(appInstance.userProfileSettings?.profileCompletion ?? 0)%"

            return cell
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutMeCellID", for: indexPath) as! AboutMeCell
            cell.selectionStyle = .none
            cell.vc = self
            
            if userSettings?.about == "" {
                cell.aboutMeLabel.text = "------"
                
            } else {
                cell.aboutMeLabel.text = userSettings?.about
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoCellID", for: indexPath) as! ProfileInfoCell
            cell.selectionStyle = .none
            cell.vc = self
            
            if userSettings?.fullName == "" {
                cell.nameLabel.text = "-----"
            }else{
                cell.nameLabel.text = userSettings?.fullName ?? "Empty"
            }
            
            if userSettings?.genderText == "" {
                cell.genderLabel.text = "-----"
            }else {
                cell.genderLabel.text = userSettings?.genderText ?? "Empty"
            }
            
            if  userSettings?.birthDay == ""{
                cell.birthdayLabel.text = "-----"
            }else{
                
                cell.birthdayLabel.text  = userSettings?.birthDay ?? "Empty"
            }
            
            if userSettings?.location == ""{
                cell.locationLabel.text = "-----"
            }else{
                
                cell.locationLabel.text = userSettings?.location ?? "Empty"
            }
            
            if userSettings?.profile.preferredLanguage.text == ""{
                cell.languageLabel.text = "-----"
            }else{
                
                cell.languageLabel.text = userSettings?.profile.preferredLanguage.text ?? "Empty"
            }
            
            if userSettings?.profile.relationShip.text == ""{
                cell.relationshipStatus.text = "-----"
            }else{
                
                cell.relationshipStatus.text = userSettings?.profile.relationShip.text ?? "Empty"
            }
            
            if userSettings?.profile.workStatus.text == "" {
                cell.workStatus.text = "-----"
            }else{
                
                
                cell.workStatus.text = userSettings?.profile.workStatus.text  ?? "Empty"
            }
            
            if userSettings?.profile.education.text == ""{
                cell.educationLabel.text = "-----"
                
            }else{
                cell.educationLabel.text = userSettings?.profile.education.text ?? "Empty"
            }
            return cell
            
        case 4:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterestsCellID", for: indexPath) as! InterestsCell
            cell.selectionStyle = .none
            cell.vc = self
            
            if userSettings?.interest == "" {
                cell.interestsLabel.text = "------"
                
            }else{
                cell.interestsLabel.text = userSettings?.interest
            }
            return cell
        case 5:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LooksCellID", for: indexPath) as! LooksCell
            cell.selectionStyle = .none
            cell.vc = self
            if userSettings?.profile.ethnicity.text == "" {
                cell.ethenicityLabel.text = "-----"
            }else{
                cell.ethenicityLabel.text = userSettings?.profile.ethnicity.text ?? "Empty"
            }
            if userSettings?.profile.body.text == "" {
                cell.bodyTypeLabel.text = "-----"
            }else{
                cell.bodyTypeLabel.text = userSettings?.profile.body.text ?? "Empty"
            }
                if userSettings?.profile.height.text == "" {
                cell.heightLabel.text = "-----"
            }else{
                cell.heightLabel.text = userSettings?.profile.height.text ?? "Empty"
            }
            if userSettings?.profile.hairColor.text == ""{
                cell.hairCOlor.text = "-----"
                
            }else{
                
                cell.hairCOlor.text = userSettings?.profile.hairColor.text ?? "Empty"
            }
            
            return cell
            
        case 6:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalityCellID", for: indexPath) as! PersonalityCell
            cell.selectionStyle = .none
            cell.vc = self
            if userSettings?.profile.character.text == ""{
                cell.characterLabel.text = "-----"
            }else{
                cell.characterLabel.text = userSettings?.profile.character.text ?? "Empty"
            }
            if userSettings?.profile.children.text == ""{
                cell.chidrenLabel.text = "-----"
            }else{
                
                cell.chidrenLabel.text = userSettings?.profile.children.text ?? "Empty"
            }
            if userSettings?.profile.friends.text == ""{
                cell.friendsLabel.text = "-----"
            }else{
                cell.friendsLabel.text = userSettings?.profile.friends.text ?? "Empty"
            }
                if userSettings?.profile.pets.text == ""{
                cell.petLabel.text = "-----"
                
            }else{
                cell.petLabel.text = userSettings?.profile.pets.text ?? "Empty"
                
            }
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LifeStyleCellID", for: indexPath) as! LifeStyleCell
            cell.selectionStyle = .none
            cell.vc = self
            if userSettings?.profile.liveWith.text == ""{

                cell.iLiveWithLabel.text = "-----"
            }else{
                cell.iLiveWithLabel.text = userSettings?.profile.liveWith.text ?? "Empty"
            }
            if userSettings?.profile.car.text == ""{
                cell.carLabel.text = "-----"
            }else{
                cell.carLabel.text = userSettings?.profile.car.text ?? "Empty"
            }
            if userSettings?.profile.religion.text == ""{
                cell.religionLabel.text = "-----"
            }else{
                cell.religionLabel.text = userSettings?.profile.religion.text  ?? "Empty"
            }
            if userSettings?.profile.smoke.text == ""{
                cell.smokeLabel.text = "-----"
                
            }else{
                
                cell.smokeLabel.text = userSettings?.profile.smoke.text  ?? "Empty"
            }
            if userSettings?.profile.drink.text == ""{
                cell.drinkLabel.text = "-----"
                
            }else{
                cell.drinkLabel.text = userSettings?.profile.drink.text ?? "Empty"
            }
            if userSettings?.profile.travel.text == ""{
                cell.travelLabel.text = "-----"
                
            }else{
                cell.travelLabel.text = userSettings?.profile.travel.text ?? "Empty"
            }
            return cell
            
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCellID", for: indexPath) as! FavouritesCell
            cell.selectionStyle = .none
            cell.vc = self
            if userSettings?.favourites.music == ""{

                cell.musicGenreLabel.text = "-----"
            }else{
                cell.musicGenreLabel.text = userSettings?.favourites.music ?? "Empty"
            }
            if userSettings?.favourites.dish == ""{
                 cell.dishLabel.text = "-----"
            }else{
                cell.dishLabel.text = userSettings?.favourites.dish ?? "Empty"
            }
            if userSettings?.favourites.song == ""{
                cell.songLabel.text = "-----"
            }else{
                cell.songLabel.text = userSettings?.favourites.song ?? "Empty"
            }
            if userSettings?.favourites.hobby == ""{
                cell.hobbyLabel.text = "-----"
            }else{
                cell.hobbyLabel.text = userSettings?.favourites.hobby ?? "Empty"
            }
            if userSettings?.favourites.city == ""{
                cell.cityLabel.text = "-----"
            }else{
                cell.cityLabel.text = userSettings?.favourites.city ?? "Empty"
            }
            if  userSettings?.favourites.sport == ""{
                cell.sportLabel.text = "-----"
            }else{
                cell.sportLabel.text = userSettings?.favourites.sport ?? "Empty"
            }
            if userSettings?.favourites.book == ""{
                 cell.bookLabel.text = "-----"
            }else{
                cell.bookLabel.text = userSettings?.favourites.book  ?? "Empty"
            }
            if userSettings?.favourites.movie == ""{
                cell.movieLabel.text = "-----"
            }else{
                cell.movieLabel.text = userSettings?.favourites.movie ?? "Empty"
            }
            if userSettings?.favourites.colour == ""{
                cell.colorLabel.text = "-----"
            }else{
                cell.colorLabel.text = userSettings?.favourites.colour ?? "Empty"
            }
            if userSettings?.favourites.tvChoice == ""{
                cell.tvShowLabel.text = "-----"
            }else{
                cell.tvShowLabel.text = userSettings?.favourites.tvChoice ?? "Empty"
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileImagesCellID", for: indexPath) as! ProfileImagesCell
            cell.selectionStyle = .none
            return cell
        }
    }
}
