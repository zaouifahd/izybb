//
//  ListFavorites.swift
//  QuickDate
//

//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation
class ListFavoriteModel{
    
    struct ListFavoriteSuccessModel {
        var status: Int?
        var message: String?
        var data: [[String:Any]]?
        
        init(json:[String:Any]) {
            let status = json["status"] as? Int
            let message = json["message"] as? String
            let data = json["data"] as? [[String:Any]]
            self.status = status ?? 0
            self.message = message ?? ""
            self.data = data ?? []
        }
    }

    struct ListFavoriteErrorModel{
        var code: Int?
        var errors: [String:Any]?
        var message: String?
        
        init(json:[String:Any]) {
            let code = json["code"] as? Int
            let errors = json["errors"] as? [String:Any]
            let message = json["message"] as? String
            self.code = code ?? 0
            self.errors = errors ?? [:]
        }
    }
    
}
