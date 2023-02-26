

import Foundation
class UpdateMediaModel:BaseModel{
    struct UpdateMediaSuccessModel: Codable {
        let data: String?
        let code: Int?
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

class deleteMediaModel:BaseModel{
    struct deleteMediaSuccessModel: Codable {
        let code: Int?
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
