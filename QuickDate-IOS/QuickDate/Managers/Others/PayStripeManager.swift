
import Foundation
import Alamofire
import QuickDateSDK

class PayStripeManager{
    static let instance = PayStripeManager()
    
    func payStripe(AccessToken:String,StripeToken:String,Paytype:String,Description:String,Price:Int, completionBlock: @escaping (_ Success:PayStripeModel.PayStripeSuccessModel?,_ SessionError:PayStripeModel.sessionErrorModel?, Error?) ->()){
        
        let params = [
            
            API.PARAMS.stripe_token: StripeToken,
            API.PARAMS.access_token: AccessToken,
             API.PARAMS.pay_type: Paytype,
             API.PARAMS.description: Description,
             API.PARAMS.price: Price,
            
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.AUTH_CONSTANT_METHODS.PAY_STRIPE_API)")
        Logger.verbose("Decoded String = \(decoded)")
        AF.request(API.AUTH_CONSTANT_METHODS.PAY_STRIPE_API, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                let apiCode = res["code"]  as? Int
                if apiCode ==  API.ERROR_CODES.E_200 {
                    Logger.verbose("apiStatus Int = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value!, options: [])
                    let result = try? JSONDecoder().decode(PayStripeModel.PayStripeSuccessModel.self, from: data!)
                    completionBlock(result,nil,nil)
                }else if apiCode ==  API.ERROR_CODES.E_400{
                    Logger.verbose("apiStatus String = \(apiCode)")
                    let data = try? JSONSerialization.data(withJSONObject: response.value as Any, options: [])
                    let result = try? JSONDecoder().decode(PayStripeModel.sessionErrorModel.self, from: data!)
                    Logger.error("AuthError = \(result?.errors?.errorText ?? "")")
                    completionBlock(nil,result,nil)
                }
                
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,nil,response.error)
            }
        }
    }
}
