
import Foundation

//class GetConversationModel:BaseModel{
//    struct GetConversationSuccessModel: Codable {
//        let code: Int?
//        let data: [Datum]?
//        let message: String?
//    }
//    
//    // MARK: - Datum
//    struct Datum: Codable {
//        let conversationStatus: Int?
//        let conversationCreatedAt: JSONNull?
//        let id:ID?
//        let owner, seen, accepted: Int?
//        let text, media, sticker, time: String?
//        let newMessages: Int?
//        let user: User?
//        let messageType: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case conversationStatus = "conversation_status"
//            case conversationCreatedAt = "conversation_created_at"
//            case id, owner, seen, accepted, text, media, sticker, time
//            case newMessages = "new_messages"
//            case user
//            case messageType = "message_type"
//        }
//    }
//    
//    // MARK: - User
//    struct User: Codable {
//        let id: String?
//        let verifiedFinal: Bool?
//        let fullname, countryTxt, webToken, password: String?
//        let age, profileCompletion: Int?
//        let profileCompletionMissing: [String]?
//        let avater: String?
//        let fullName, username, email, firstName: String?
//        let lastName, address, gender, genderTxt: String?
//        let facebook, google, twitter, linkedin: String?
//        let website, instagram, webDeviceID, language: String?
//        let languageTxt, emailCode, src, ipAddress: String?
//        let type, phoneNumber, timezone, lat: String?
//        let lng, about, birthday, country: String?
//        let registered, lastseen, smscode, proTime: String?
//        let lastLocationUpdate, balance, verified, status: String?
//        let active, admin, startUp, isPro: String?
//        let proType, socialLogin, createdAt, updatedAt: String?
//        let deletedAt, mobileDeviceID, mobileToken, height: String?
//        let heightTxt, hairColor, hairColorTxt, webTokenCreatedAt: String?
//        let mobileTokenCreatedAt, mobileDevice, interest, location: String?
//        let relationship, relationshipTxt, workStatus, workStatusTxt: String?
//        let education, educationTxt, ethnicity, ethnicityTxt: String?
//        let body, bodyTxt, character, characterTxt: String?
//        let children, childrenTxt, friends, friendsTxt: String?
//        let pets, petsTxt, liveWith, liveWithTxt: String?
//        let car, carTxt, religion, religionTxt: String?
//        let smoke, smokeTxt, drink, drinkTxt: String?
//        let travel, travelTxt, music, dish: String?
//        let song, hobby, city, sport: String?
//        let book, movie, colour, tv: String?
//        let privacyShowProfileOnGoogle, privacyShowProfileRandomUsers, privacyShowProfileMatchProfiles, emailOnProfileView: String?
//        let emailOnNewMessage, emailOnProfileLike, emailOnPurchaseNotifications, emailOnSpecialOffers: String?
//        let emailOnAnnouncements, phoneVerified, online, isBoosted: String?
//        let boostedTime, isBuyStickers, userBuyXvisits, xvisitsCreatedAt: String?
//        let userBuyXmatches, xmatchesCreatedAt, userBuyXlikes, xlikesCreatedAt: String?
//        let showMeTo, emailOnGetGift, emailOnGotNewMatch, emailOnChatRequest: String?
//        let lastEmailSent, approvedAt, snapshot, hotCount: String?
//        let spamWarning, activationRequestCount, lastActivationRequest, lastseenTxt: String?
//        let mediafiles: [Mediafile]?
//        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case verifiedFinal = "verified_final"
//            case fullname
//            case countryTxt = "country_txt"
//            case webToken = "web_token"
//            case password, age
//            case profileCompletion = "profile_completion"
//            case profileCompletionMissing = "profile_completion_missing"
//            case avater
//            case fullName = "full_name"
//            case username, email
//            case firstName = "first_name"
//            case lastName = "last_name"
//            case address, gender
//            case genderTxt = "gender_txt"
//            case facebook, google, twitter, linkedin, website, instagram
//            case webDeviceID = "web_device_id"
//            case language
//            case languageTxt = "language_txt"
//            case emailCode = "email_code"
//            case src
//            case ipAddress = "ip_address"
//            case type
//            case phoneNumber = "phone_number"
//            case timezone, lat, lng, about, birthday, country, registered, lastseen, smscode
//            case proTime = "pro_time"
//            case lastLocationUpdate = "last_location_update"
//            case balance, verified, status, active, admin
//            case startUp = "start_up"
//            case isPro = "is_pro"
//            case proType = "pro_type"
//            case socialLogin = "social_login"
//            case createdAt = "created_at"
//            case updatedAt = "updated_at"
//            case deletedAt = "deleted_at"
//            case mobileDeviceID = "mobile_device_id"
//            case mobileToken = "mobile_token"
//            case height
//            case heightTxt = "height_txt"
//            case hairColor = "hair_color"
//            case hairColorTxt = "hair_color_txt"
//            case webTokenCreatedAt = "web_token_created_at"
//            case mobileTokenCreatedAt = "mobile_token_created_at"
//            case mobileDevice = "mobile_device"
//            case interest, location, relationship
//            case relationshipTxt = "relationship_txt"
//            case workStatus = "work_status"
//            case workStatusTxt = "work_status_txt"
//            case education
//            case educationTxt = "education_txt"
//            case ethnicity
//            case ethnicityTxt = "ethnicity_txt"
//            case body
//            case bodyTxt = "body_txt"
//            case character
//            case characterTxt = "character_txt"
//            case children
//            case childrenTxt = "children_txt"
//            case friends
//            case friendsTxt = "friends_txt"
//            case pets
//            case petsTxt = "pets_txt"
//            case liveWith = "live_with"
//            case liveWithTxt = "live_with_txt"
//            case car
//            case carTxt = "car_txt"
//            case religion
//            case religionTxt = "religion_txt"
//            case smoke
//            case smokeTxt = "smoke_txt"
//            case drink
//            case drinkTxt = "drink_txt"
//            case travel
//            case travelTxt = "travel_txt"
//            case music, dish, song, hobby, city, sport, book, movie, colour, tv
//            case privacyShowProfileOnGoogle = "privacy_show_profile_on_google"
//            case privacyShowProfileRandomUsers = "privacy_show_profile_random_users"
//            case privacyShowProfileMatchProfiles = "privacy_show_profile_match_profiles"
//            case emailOnProfileView = "email_on_profile_view"
//            case emailOnNewMessage = "email_on_new_message"
//            case emailOnProfileLike = "email_on_profile_like"
//            case emailOnPurchaseNotifications = "email_on_purchase_notifications"
//            case emailOnSpecialOffers = "email_on_special_offers"
//            case emailOnAnnouncements = "email_on_announcements"
//            case phoneVerified = "phone_verified"
//            case online
//            case isBoosted = "is_boosted"
//            case boostedTime = "boosted_time"
//            case isBuyStickers = "is_buy_stickers"
//            case userBuyXvisits = "user_buy_xvisits"
//            case xvisitsCreatedAt = "xvisits_created_at"
//            case userBuyXmatches = "user_buy_xmatches"
//            case xmatchesCreatedAt = "xmatches_created_at"
//            case userBuyXlikes = "user_buy_xlikes"
//            case xlikesCreatedAt = "xlikes_created_at"
//            case showMeTo = "show_me_to"
//            case emailOnGetGift = "email_on_get_gift"
//            case emailOnGotNewMatch = "email_on_got_new_match"
//            case emailOnChatRequest = "email_on_chat_request"
//            case lastEmailSent = "last_email_sent"
//            case approvedAt = "approved_at"
//            case snapshot
//            case hotCount = "hot_count"
//            case spamWarning = "spam_warning"
//            case activationRequestCount = "activation_request_count"
//            case lastActivationRequest = "last_activation_request"
//            case lastseenTxt = "lastseen_txt"
//            case mediafiles
//        }
//    }
//    
//    // MARK: - Mediafile
//    struct Mediafile: Codable {
//        let id: Int?
//        let full, avater: String?
//        let isPrivate: Int?
//        let privateFileFull, privateFileAvater: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case id, full, avater
//            case isPrivate = "is_private"
//            case privateFileFull = "private_file_full"
//            case privateFileAvater = "private_file_avater"
//        }
//    }
//    
//    // MARK: - Errors
//    struct Errors: Codable {
//        let errorID, errorText: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case errorID = "error_id"
//            case errorText = "error_text"
//        }
//    }
//    enum ID: Codable {
//        case integer(Int)
//        case string(String)
//        
//        var stringValue : String? {
//            guard case let .string(value) = self else { return nil }
//            return value
//        }
//        
//        var intValue : Int? {
//            guard case let .integer(value) = self else { return nil }
//            return value
//        }
//        
//        init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if let x = try? container.decode(Int.self) {
//                self = .integer(x)
//                return
//            }
//            if let x = try? container.decode(String.self) {
//                self = .string(x)
//                return
//            }
//            throw DecodingError.typeMismatch(ID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for CountViews"))
//        }
//        
//        func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            switch self {
//            case .integer(let x):
//                try container.encode(x)
//            case .string(let x):
//                try container.encode(x)
//            }
//        }
//    }
//    
//    // MARK: - Encode/decode helpers
//    
//    class JSONNull: Codable, Hashable {
//        
//        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//        }
//        
//        public var hashValue: Int {
//            return 0
//        }
//        
//        public init() {}
//        
//        public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//        }
//        
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//        }
//    
//}
//}
//class GetChatConversationModel:BaseModel{
//    struct GetChatConversationSuccessModel: Codable {
//        let code: Int?
//        let message: String?
//        let data: [Datum]?
//      
//    }
//    
//    // MARK: - Datum
//    struct Datum: Codable {
//        let id: Int?
//        let fromName: String?
//        let fromAvater: String?
//        let toName: String?
//        let toAvater: String?
//        let from, to: Int?
//        let text, media: String?
//        let fromDelete, toDelete: Int?
//        let sticker: String?
//        let seen: Int?
//        let type, messageType: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case fromName = "from_name"
//            case fromAvater = "from_avater"
//            case toName = "to_name"
//            case toAvater = "to_avater"
//            case from, to, text, media
//            case fromDelete = "from_delete"
//            case toDelete = "to_delete"
//            case sticker
//            case seen, type
//            case messageType = "message_type"
//        }
//    }
//    
//    // MARK: - Errors
//    struct Errors: Codable {
//        let errorID, errorText: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case errorID = "error_id"
//            case errorText = "error_text"
//        }
//    }
//}
class ClearChatModel:BaseModel{
    struct ClearChatSuccessModel: Codable {
        let status: Int?
        let message: String?
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
//class SendMessageModel:BaseModel{
//    // MARK: - Welcome
//    struct SendMessageSuccessModel: Codable {
//        let status: Int?
//        let message: String?
//        let data: DataClass?
//        let hashID: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case status, message, data
//            case hashID = "hash_id"
//        }
//    }
//    
//    // MARK: - DataClass
//    struct DataClass: Codable {
//        let id, from, fromDelete, to: Int?
//        let toDelete: Int?
//        let text, media, sticker: String?
//        let seen: Int?
//        let createdAt, messageType: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case id, from
//            case fromDelete = "from_delete"
//            case to
//            case toDelete = "to_delete"
//            case text, media, sticker, seen
//            case createdAt = "created_at"
//            case messageType = "message_type"
//        }
//    }
//    
//    // MARK: - Errors
//    struct Errors: Codable {
//        let errorID, errorText: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case errorID = "error_id"
//            case errorText = "error_text"
//        }
//    }
//}
//class sendStickerModel:BaseModel{
//    struct sendStickerSuccessModel: Codable {
//        let status: Int?
//        let message: String?
//        let data: DataClass?
//        let hashID: String?
//
//        enum CodingKeys: String, CodingKey {
//            case status, message, data
//            case hashID = "hash_id"
//        }
//    }
//
//    // MARK: - DataClass
//    struct DataClass: Codable {
//        let id, from, fromDelete, to: Int?
//        let toDelete: Int?
//        let text, media: String?
//        let sticker, seen: Int?
//        let createdAt, messageType: String?
//
//        enum CodingKeys: String, CodingKey {
//            case id, from
//            case fromDelete = "from_delete"
//            case to
//            case toDelete = "to_delete"
//            case text, media, sticker, seen
//            case createdAt = "created_at"
//            case messageType = "message_type"
//        }
//    }
//
//    // MARK: - Errors
//    struct Errors: Codable {
//        let errorID, errorText: String?
//
//        enum CodingKeys: String, CodingKey {
//            case errorID = "error_id"
//            case errorText = "error_text"
//        }
//    }
//}
class sendGiftModel:BaseModel{
    struct sendGiftSuccessModel: Codable {
        let status: Int?
        let message: String?
        let data: DataClass?
        let hashID: String?
        
        enum CodingKeys: String, CodingKey {
            case status, message, data
            case hashID = "hash_id"
        }
    }
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id, from, fromDelete, to: Int?
        let toDelete: Int?
        let text, media: String?
        let sticker, seen: Int?
        let createdAt, messageType: String?
        
        enum CodingKeys: String, CodingKey {
            case id, from
            case fromDelete = "from_delete"
            case to
            case toDelete = "to_delete"
            case text, media, sticker, seen
            case createdAt = "created_at"
            case messageType = "message_type"
        }
    }
    
    // MARK: - Errors
    struct Errors: Codable {
        let errorID, errorText: String?
        
        enum CodingKeys: String, CodingKey {
            case errorID = "error_id"
            case errorText = "error_text"
        }
    }
}
//class SendMediaModel:BaseModel{
//    struct SendMediaSuccessModel: Codable {
//        let code: Int?
//        let message: String?
//        let data: DataClass?
//        let hashID: String?
//        let errors: Errors?
//        
//        enum CodingKeys: String, CodingKey {
//            case code, message, data
//            case hashID = "hash_id"
//            case errors
//        }
//    }
//    
//    // MARK: - DataClass
//    struct DataClass: Codable {
//        let id, from, fromDelete, to: Int?
//        let toDelete: Int?
//        let text, media, sticker: String?
//        let seen: Int?
//        let createdAt, messageType: String?
//        
//        enum CodingKeys: String, CodingKey {
//            case id, from
//            case fromDelete = "from_delete"
//            case to
//            case toDelete = "to_delete"
//            case text, media, sticker, seen
//            case createdAt = "created_at"
//            case messageType = "message_type"
//        }
//    }
//    
//}
