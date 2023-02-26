//
//  UserProfileSettings.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 14.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

// MARK: - UserProfileSettings
class UserProfileSettings {

    var userId: Int
    var username, email, firstName, lastName: String
    var fullName, birthDay, location: String
    var genderCode, genderText: String
    var phoneNumber, country, about: String
    
    var profileCompletion: Int
    
    var profile: ProfileFeatures
    
    var favourites: Favourites

    var isProUser: Bool
    var interest: String
    var blocks: [Relation]
    var likes: [Relation]
    var balance: Double
    
    var twoFactor, twoFactorVerified: Bool
    var twoFactorEmailCode: String
    
    // Privacy
    var showProfileOnGoogle: Bool
    var showProfileToRandomUsers: Bool
    var showProfileToMatchProfiles: Bool
    
    // Links
    var avatar: String
    var facebookURL: String
    var googleURL: String
    var twitterURL: String
    var linkedinURL: String
    var websiteURL: String
    var instagramURL: String
    
    var mediaFiles: [MediaFile]
    
    var likesCount, visitsCount: Int
    
    var gender: Gender {
        return Gender(stringValue: genderCode)
    }
    
    var avatarURL: URL? {
        return URL(string: avatar)
    }
    
    init(dict: JSON) {
        self.userId = dict["id"] as? Int ?? 0
        self.username = dict["username"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.firstName = dict["first_name"] as? String ?? ""
        self.lastName = dict["last_name"] as? String ?? ""
        self.fullName = dict["full_name"] as? String ?? ""
        self.birthDay = dict["birthday"] as? String ?? ""
        self.location = dict["location"] as? String ?? ""
        self.genderCode = dict["gender"] as? String ?? ""
        self.genderText = dict["gender_txt"] as? String ?? ""
        self.phoneNumber = dict["phone_number"] as? String ?? ""
        self.country = dict["country"] as? String ?? ""
        self.about = dict["about"] as? String ?? ""
        
        self.profileCompletion = dict["profile_completion"] as? Int ?? 0

        self.twoFactor = dict.getBoolType(with: "two_factor")
        self.twoFactorVerified = dict.getBoolType(with: "two_factor_verified")
        self.twoFactorEmailCode = dict["two_factor_email_code"] as? String ?? ""
        
        self.profile = ProfileFeatures(from: dict)
        self.favourites = Favourites(from: dict)

        self.isProUser = dict.getBoolType(with: "is_pro")
        self.interest = dict["interest"] as? String ?? ""
        
        self.blocks = dict.getRelationList(type: .blocked, with: "bloks")
        self.likes = dict.getRelationList(type: .liked, with: "likes")
        
        let balance =  dict["balance"] as? String ?? ""
        self.balance = Double(balance) ?? 0.0
        
        self.showProfileOnGoogle = dict.getBoolType(with: "privacy_show_profile_on_google")
        self.showProfileToRandomUsers = dict.getBoolType(with: "privacy_show_profile_random_users")
        self.showProfileToMatchProfiles = dict.getBoolType(with: "privacy_show_profile_match_profiles")
        
        self.avatar = dict["avater"] as? String ?? ""
        self.facebookURL = dict["facebook"] as? String ?? ""
        self.googleURL = dict["google"] as? String ?? ""
        self.twitterURL = dict["twitter"] as? String ?? ""
        self.linkedinURL = dict["linkedin"] as? String ?? ""
        self.websiteURL = dict["website"] as? String ?? ""
        self.instagramURL = dict["instagram"] as? String ?? ""
        
        self.mediaFiles = dict.getMediaFileList(with: "mediafiles")
        
        self.likesCount = dict["likes_count"] as? Int ?? 0
        self.visitsCount = dict["visits_count"] as? Int ?? 0

    }
    
}

// MARK: - UserInteractions

enum UserInteraction {
    case like
    case dislike
}

// MARK: - Relation
class Relation {
    
    enum RelationType {
        case liked
        case blocked
    }
    
    let relationType: RelationType
    
    let like: UserInteraction?
    
    let id, userIdOfRelatedUser: Int
    let username, firstName, lastName, fullName: String
    let genderCode, avatarURL: String
    
    init(type: RelationType, from dict: JSON) {
        self.relationType = type
        self.id = dict["id"] as? Int ?? 0
        let userIdKey: String = type == .liked ? "like_userid" : "block_userid"
        self.userIdOfRelatedUser = dict[userIdKey] as? Int ?? 0
        
        if type == .liked {
            let isLike = dict["is_like"] as? Int ?? 0 == 1 && dict["is_dislike"] as? Int ?? 0 == 0
            self.like = isLike ? .like : .dislike
        } else {
            self.like = nil
        }
        
        let data = dict["data"] as? JSON
        self.username = data?["username"] as? String ?? ""
        self.firstName = data?["first_name"] as? String ?? ""
        self.lastName = data?["last_name"] as? String ?? ""
        self.fullName = data?["full_name"] as? String ?? ""
        self.genderCode = data?["gender"] as? String ?? ""
        self.avatarURL = data?["avater"] as? String ?? ""

    }
    
}
