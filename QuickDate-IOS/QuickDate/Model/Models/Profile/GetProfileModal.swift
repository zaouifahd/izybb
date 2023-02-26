//
//  GetProfileModal.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/18/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation

class GetProfileModal:BaseModel{

    struct getProfile_SuccessModal {
        var data: [String:Any]
        var message: String
        var code: Int
        var errors: [String:Any]
        init(json:[String:Any]) {
            let data = json["data"] as? [String:Any]
            let messsgae = json["message"] as? String
            let code = json["code"] as? Int
            let errors = json["errors"] as? [String:Any]
            self.data = data ?? ["":""]
            self.message = messsgae ?? ""
            self.code = code ?? 0
            self.errors = errors ?? ["":""]
        }
    }
}
