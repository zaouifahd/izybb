

import Foundation
import Alamofire
import QuickDateSDK

class ProfileManger {
    // MARK: - Properties
    static let instance = ProfileManger()
    // Property Injections
    private let networkManager: NetworkManager
    
    private init() {
        networkManager = .shared
    }
    
    func updateAccount(with parameters: APIParameters, completion: @escaping (Result<String, Error>) -> Void) {

        let url = API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API

        let accessToken = AppInstance.shared.accessToken ?? ""

        var params: APIParameters = [
            API.PARAMS.access_token: accessToken
        ]
        parameters.forEach { params[$0.key] = $0.value }

        networkManager.fetchDataWithRequest(urlString: url, method: .post,
                                            parameters: params) { (result: Result<JSON, Error>) in
            
            switch result {
            case .failure(let error):
                completion(.failure(RemoteDataError.known(error.localizedDescription)))
                
            case .success(_):
                completion(.success("Updated successfully...".localized))
            }
        }
    }
    
    func getProfile(UserId:Int,AccessToken:String,FetchString:String, completionBlock: @escaping (_ Success:[String:Any]?,_ SessionError:[String:Any]?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.user_id: UserId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.fetch: FetchString
            
            ] as [String : Any]
        
        print(params)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.PROFILE_API,
                   method: .post,
                   parameters: params,
                   encoding:URLEncoding.default,
                   headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(UserProfileModel.UserProfileSuccessModel.self, from: data!)
                    completionBlock(res,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(UserProfileModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,res,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    
    
    func updateAccount(AccessToken:String, username: String, email: String, phone: String, country: String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.username: username,
            API.PARAMS.email: email,
            API.PARAMS.phone_number: phone,
            API.PARAMS.country: country
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                  
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func changePassoword(AccessToken:String, currentPwd: String, newPwd: String, repeatNewPwd: String, completionBlock: @escaping (_ Success:ChangePasswordModel.ChangePasswordSuccessModel?,_ SessionError:ChangePasswordModel.CHangePasswordErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.c_pass: currentPwd,
            API.PARAMS.n_pass: newPwd,
            API.PARAMS.cn_pass: repeatNewPwd
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.CHANGE_PASSWORD_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.CHANGE_PASSWORD_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ChangePasswordModel.ChangePasswordSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ChangePasswordModel.CHangePasswordErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateSocialLinks(AccessToken:String,  facebook: String, twitter: String, google: String, instagram: String, linkedIn: String, website: String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.facebook: facebook,
            API.PARAMS.twitter: twitter,
            API.PARAMS.google: google,
            API.PARAMS.instagram: instagram,
            API.PARAMS.linkedin: linkedIn,
            API.PARAMS.website: website
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateSettings(AccessToken:String,  searchEngine: Int, randomUser: Int, matchPage: Int, activeness: Int, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.privacy_show_profile_on_google: searchEngine,
            API.PARAMS.privacy_show_profile_random_users: randomUser,
            API.PARAMS.privacy_show_profile_match_profiles: matchPage
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editProfile(AccessToken:String,Firstname:String,LastName:String,Gender:String,Birthday:String,Location:String,language:String,RelationShip:String,workStatus:String,Education:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.first_name: Firstname,
            API.PARAMS.last_name: LastName,
            API.PARAMS.gender: Gender,
            API.PARAMS.birthday: Birthday,
            API.PARAMS.location: Location,
            API.PARAMS.language: language,
            API.PARAMS.relationship: RelationShip,
            API.PARAMS.work_status: workStatus,
            API.PARAMS.education: Education,
            
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editLooks(AccessToken:String,Color:String,Body:String,Height:String,Ethnicity:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.colour: Color,
            API.PARAMS.body: Body,
            API.PARAMS.height: Height,
            API.PARAMS.ethnicity: Ethnicity
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editPersonality(AccessToken:String,Character:String,Children:String,Friends:String,Pet:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.character: Character,
            API.PARAMS.children: Children,
            API.PARAMS.friends: Friends,
            API.PARAMS.pets: Pet
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editLifeStyle(AccessToken:String,Livewith:String,Car:String,Religion:String,smoke:String,Drink:String,Travel:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.live_with: Livewith,
            API.PARAMS.car: Car,
            API.PARAMS.religion: Religion,
            API.PARAMS.smoke: smoke,
            API.PARAMS.drink: Drink,
            API.PARAMS.travel: Travel
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func editFavourite(AccessToken:String,Music:String,Dish:String,Song:String,Hobby:String,City:String,Sport:String,Book:String,Movie:String,Color:String,Tvshow:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.music: Music,
            API.PARAMS.dish: Dish,
            API.PARAMS.song: Song,
            API.PARAMS.hobby: Hobby,
            API.PARAMS.city: City,
            API.PARAMS.sport: Sport,
            API.PARAMS.book: Book,
            API.PARAMS.movie: Movie,
            API.PARAMS.colour: Color,
            API.PARAMS.tv: Tvshow,
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateAboutMe(AccessToken:String,  AboutMeText: String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.about: AboutMeText
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateInterest(AccessToken:String,  InterestText: String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.interest: InterestText
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            Logger.verbose("UpdateProfileResult = \(response.value)")
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateTwoaFactor(UserId:Int,AccessToken:String,email:String, completionBlock: @escaping (_ Success:TwoFactorVerifyCodeModel.TwoFactorVerifyCodeSuccessModel?,_ SessionError:TwoFactorVerifyCodeModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.user_id: UserId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.new_email: email
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.TWO_FACTOR_SETTINGS_CONSTANT.TWO_FACTOR_SETTINGS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.TWO_FACTOR_SETTINGS_CONSTANT.TWO_FACTOR_SETTINGS_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    Logger.verbose("apiStatus Int = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(TwoFactorVerifyCodeModel.TwoFactorVerifyCodeSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiStatus)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(TwoFactorVerifyCodeModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func verifyTwoFactorCode(UserId:Int,AccessToken:String,twoFactorCode:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.user_id: UserId,
            API.PARAMS.access_token: AccessToken,
            API.PARAMS.two_factor_email_code: twoFactorCode
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                    completionBlock(result,nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result = ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                    completionBlock(nil,result,nil)
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
    func updateTwoFactorProfile(UserId:Int,AccessToken:String,twoFactor:String, completionBlock: @escaping (_ Success:ProfileUpdateModel.ProfileUpdateSuccessModel?,_ SessionError:ProfileUpdateModel.ProfileUpdateErrorModel?, Error?) ->()){
           
           let params = [
               
//               API.PARAMS.user_id: UserId,
               API.PARAMS.access_token: AccessToken,
               API.PARAMS.two_factor: twoFactor
               
               ] as [String : Any]
           
           let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
           Logger.verbose("Targeted URL = \(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API)")
           Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.USERS_CONSTANT_METHODS.UPDATE_PROFILE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
               
               if (response.value != nil){
                   guard let res = response.value as? [String:Any] else {return}
                   guard let apiStatus = res["code"]  as? Int else {return}
                   if apiStatus ==  API.ERROR_CODES.E_200{
                    let result = ProfileUpdateModel.ProfileUpdateSuccessModel.init(json: res)
                       completionBlock(result,nil,nil)
                   }else if apiStatus ==  API.ERROR_CODES.E_400{
                    let result =  ProfileUpdateModel.ProfileUpdateErrorModel.init(json: res)
                       completionBlock(nil,result,nil)
                   }
               }else{
                   Logger.error("error = \(response.error?.localizedDescription ?? "")")
                   completionBlock(nil,nil,response.error)
               }
           }
       }
}


