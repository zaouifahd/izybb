//
//  TrendingCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import SDWebImage
import RealmSwift
import QuickDateSDK

class TrendingCollectionItem: UICollectionViewCell {
    
    // MARK: - Views
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    // Constraints
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var user: RandomUser? {
        didSet {
            self.profileImage.sd_setImage(with: user?.avatarURL, placeholderImage: .thumbnail)
            self.userNameLabel.text  = user?.fullName
            self.timeLabel.text =  self.setTimestamp(epochTime: String(user?.lastseen ?? 0))
            
            let isLiked = user?.isLiked ?? false
            self.handleLikeButtonImage(with: isLiked)
            self.likeStatus = isLiked
        }
    }
    
    var indexPathRow: Int? {
        didSet {
            guard let indexPathRow = indexPathRow else {
                Logger.error("getting indexPathRow"); return
            }
            let isEven: Bool = indexPathRow % 2 == 0 ? true : false
            leadingConstraint.constant =  isEven ? 16 : 8
            leadingConstraint.isActive = true
            trailingConstraint.constant = isEven ? 8 : 16
            trailingConstraint.isActive = true
            self.layoutIfNeeded()
        }
    }
    
    private let networkManager: NetworkManager = .shared
    private let appInstance: AppInstance = .shared
    
    var viewController: UIViewController?
    
    var baseVC: BaseViewController?
//    var uid: Int? = 0
    private var likeStatus: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Services
    
    private func getLikeOrDislike() {
        guard appInstance.isConnectedToNetwork(in: self.viewController?.view) else { return }
        
        guard let user = user else { // Safety check
            Logger.error("getting user"); return
        }
        let accessToken = AppInstance.shared.accessToken ?? ""
        var params: APIParameters = [API.PARAMS.access_token: accessToken]
        // If true delete like else add like
        switch likeStatus {
        case true:  params[API.PARAMS.user_likeid] = "\(user.userId)"
        case false: params[API.PARAMS.likes] = "\(user.userId)"
        }
        // change url according to likeStatus
        let urlString = likeStatus
        ? API.USERS_CONSTANT_METHODS.DELETE_LIKE_API : API.USERS_CONSTANT_METHODS.ADD_LIKES_API
        
        Async.background({
            self.networkManager.fetchDataWithRequest(urlString: urlString, method: .post,
                                                parameters: params, successCode: .code) { response in
                switch response {
                case .failure(let error):
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.viewController?.view.makeToast(error.localizedDescription)
                            Logger.error("error = \(error)")
                        }
                    })
                case .success(_):
                    Async.main({
                        self.baseVC?.dismissProgressDialog {
                            self.likeStatus = !self.likeStatus
                            self.handleLikeButtonImage(with: self.likeStatus)
                        }
                    })
                }
            }
        })
       
    }
    
    // MARK: - Private Functions
    
    private func handleLikeButtonImage(with likeStatus: Bool) {
        let image: UIImage? = likeStatus ? .heartFill : .heartEmpty
        let color: UIColor? = likeStatus ? .heartRed : .white
        self.likeBtn.setImage(image, for: .normal)
        self.likeBtn.tintColor = color
    }
    
    private func setTimestamp(epochTime: String) -> String {
        let currentDate = Date()
        
        let epochDate = Date(timeIntervalSince1970: TimeInterval(epochTime) as! TimeInterval)
        
        let calendar = Calendar.current
        
        let currentDay = calendar.component(.day, from: currentDate)
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinutes = calendar.component(.minute, from: currentDate)
        let currentSeconds = calendar.component(.second, from: currentDate)
        
        let epochDay = calendar.component(.day, from: epochDate)
        let epochMonth = calendar.component(.month, from: epochDate)
        let epochYear = calendar.component(.year, from: epochDate)
        let epochHour = calendar.component(.hour, from: epochDate)
        let epochMinutes = calendar.component(.minute, from: epochDate)
        let epochSeconds = calendar.component(.second, from: epochDate)
        
        if (currentDay - epochDay < 30) {
            if (currentDay == epochDay) {
                if (currentHour - epochHour == 0) {
                    if (currentMinutes - epochMinutes == 0) {
                        if (currentSeconds - epochSeconds <= 1) {
                            return String(currentSeconds - epochSeconds) + " second ago"
                        } else {
                            return String(currentSeconds - epochSeconds) + " seconds ago"
                        }
                        
                    } else if (currentMinutes - epochMinutes <= 1) {
                        return String(currentMinutes - epochMinutes) + " minute ago"
                    } else {
                        return String(currentMinutes - epochMinutes) + " minutes ago"
                    }
                } else if (currentHour - epochHour <= 1) {
                    return String(currentHour - epochHour) + " hour ago"
                } else {
                    return String(currentHour - epochHour) + " hours ago"
                }
            } else if (currentDay - epochDay <= 1) {
                return String(currentDay - epochDay) + " day ago"
            } else {
                return String(currentDay - epochDay) + " days ago"
            }
        } else {
            return String(epochDay) + " " + getMonthNameFromInt(month: epochMonth) + " " + String(epochYear)
        }
    }
    
    private func getMonthNameFromInt(month: Int) -> String {
        switch month {
        case 1:
            return "Jan"
        case 2:
            return "Feb"
        case 3:
            return "Mar"
        case 4:
            return "Apr"
        case 5:
            return "May"
        case 6:
            return "Jun"
        case 7:
            return "Jul"
        case 8:
            return "Aug"
        case 9:
            return "Sept"
        case 10:
            return "Oct"
        case 11:
            return "Nov"
        case 12:
            return "Dec"
        default:
            return ""
        }
    }
    
    // MARK: - Actions
    
    @IBAction func heartPressed(_ sender: Any) {
        let uid = user?.userId ?? 0
        self.getLikeOrDislike()
        
    }
}

extension TrendingCollectionItem: NibReusable {}
