//
//  OtherUser+Enum.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 21.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import GoogleMaps
//import GooglePlaces
import CoreLocation

enum OtherUser {
    case randomUser(RandomUser)
    case notifier(NotifierUser)
    case userProfile(UserProfile)

    var shallNotify: Bool {
        switch self {
        case .randomUser(_):  return false
        case .notifier(_):    return true
        case .userProfile(_): return false
        }
    }
    
    var mediaFiles: [MediaFile] {
        switch self {
        case .randomUser(let randomUser): return randomUser.mediaFiles
        case .notifier(let notifierUser): return notifierUser.mediaFiles
        case .userProfile(let profile):   return profile.mediaFiles
        }
    }
    
    var userDetails: UserDetailFeatures {
        switch self {
        case .randomUser(let user):
            let social = SocialMedia(
                google: user.google, facebook: user.facebook, instagram: user.instagram, webSite: user.website, linkedin: user.linkedin, twitter: user.twitter)
            
            let countryText = fetchCountry(with: user.country)
            
            return UserDetailFeatures(
                userName: user.username,
                fullName: user.fullName,
                avatar: user.avatar,
                isFavorite: user.isFavorite,
                id: user.userId,
                lastseen: user.lastseen,
                about: user.about,
                country: countryText,
                interest: user.interest,
                mediaFileList: user.mediaFiles,
                profile: user.profile,
                socialMedia: social,
                favourites: user.favourites,
                coordinate: user.coordinate
            )
            
        case .notifier(let notifierUser):
            let social = SocialMedia(
                google: notifierUser.google, facebook: notifierUser.facebook,
                instagram: notifierUser.instagram, webSite: notifierUser.website, linkedin: notifierUser.linkedin, twitter: notifierUser.twitter)
            
            let countryText = fetchCountry(with: notifierUser.country)
            
            return UserDetailFeatures(
                userName: notifierUser.username,
                fullName: notifierUser.fullName,
                avatar: notifierUser.avatar,
                isFavorite: nil,
                id: notifierUser.userId,
                lastseen: notifierUser.lastseen,
                about: notifierUser.about,
                country: countryText,
                interest: notifierUser.interest,
                mediaFileList: notifierUser.mediaFiles,
                profile: notifierUser.profile, 
                socialMedia: social,
                favourites: notifierUser.favourites,
                coordinate: notifierUser.coordinate
            )
            
        case .userProfile(let user):
            let social = SocialMedia(
                google: user.google, facebook: user.facebook, instagram: user.instagram, webSite: user.website, linkedin: user.linkedin, twitter: user.twitter)
            
            let countryText = fetchCountry(with: user.country)
            
            return UserDetailFeatures(
                userName: user.username,
                fullName: user.fullName,
                avatar: user.avatar,
                isFavorite: user.isFavorite,
                id: user.userId,
                lastseen: user.lastseen,
                about: user.about,
                country: countryText,
                interest: user.interest,
                mediaFileList: user.mediaFiles,
                profile: user.profile,
                socialMedia: social,
                favourites: user.favourites,
                coordinate: user.coordinate
            )
        }
    }
}

extension OtherUser {
    
    private func fetchCountry(with countryCode: String) -> String? {
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
            Logger.error("getting path"); return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(Countries.self, from: data)
            let country = result.countries.filter { $0.code == countryCode }.first
            return country?.name
        } catch {
            Logger.error(error)
            return nil
        }
    }
}

// MARK: - Countries
struct Countries: Codable {
    let countries: [Country]
}

// MARK: - Country
struct Country: Codable {
    let code, name, letter: String
}
