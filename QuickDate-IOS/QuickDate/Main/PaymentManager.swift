//
//  PaymentManager.swift
//  QuickDate
//
//  Created by Sourav Mishra on 26/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import Alamofire
import QuickDateSDK
import SwiftyJSON
import UIKit

class PaymentManager {
    static let instance = PaymentManager()

    func razorPaySuccess(AccessToken:String,payment_id:String,merchant_amount:String, completionBlock: @escaping (_ Success:JSON?, String?) ->()){
        
        let params = [
            "payment_id": payment_id,
             "merchant_amount": merchant_amount,
            API.PARAMS.access_token: AccessToken,
            "order_id": payment_id
            ] as [String : Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [])
        let decoded = String(data: jsonData!, encoding: .utf8)!
        Logger.verbose("Targeted URL = \(API.COMMON_CONSTANT_METHODS.GET_NOTIFICATIONS_API)")
        Logger.verbose("Decoded String = \(decoded)")
        let urlString = "https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/razorpay/create"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    completionBlock(nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    completionBlock(nil,"Error 400")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func authorizePaySuccess(params: [String : Any], completionBlock: @escaping (_ Success:JSON?, String?) ->()){
        let urlString = "https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/authorize/pay"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["status"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    completionBlock(nil,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
    
    func iyzipayCreateSession(params: [String : Any], completionBlock: @escaping (_ Success:String?, String?) ->()){
        let urlString = "https://quickdatescript.com/endpoint/v1/15ac233b9b961e39d52c27de30e2ef32f703dc04/iyzipay/createsession"
        AF.request(urlString, method: .post, parameters: params, encoding:URLEncoding.default, headers: nil).responseJSON { (response) in
            if (response.value != nil){
                guard let res = response.value as? [String:Any] else {return}
                guard let apiStatus = res["code"]  as? Int else {return}
                if apiStatus ==  API.ERROR_CODES.E_200{
                    let htmlText = res["html"] as? String ?? ""
                    completionBlock(htmlText,nil)
                }else if apiStatus ==  API.ERROR_CODES.E_400{
                    completionBlock(nil, res["message"] as? String ?? "Please check your details")
                }
            }else{
                Logger.error("error = \(response.error?.localizedDescription ?? "")")
                completionBlock(nil,response.error?.localizedDescription)
            }
        }
    }
}
