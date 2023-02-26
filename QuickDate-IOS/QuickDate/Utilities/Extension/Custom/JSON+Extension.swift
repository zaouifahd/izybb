//
//  JSON+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 19.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

extension JSON {
    
    /// Get Choice Property which has early set choices from server and its texts to provide clear code
    /// - Parameters:
    ///   - dict: JSON value from server
    ///   - keys: type and text key
    /// - Returns: [ChoiceProperty](x-source-tag://ChoiceProperty)
    func getChoice(with keys: ChoiceProperty ) -> ChoiceProperty {
        let type = self[keys.type] as? String ?? ""
        let text = self[keys.text] as? String ?? ""
        return (type, text)
    }
    
    /// Handle return statement in initializer
    func returnNonOptional(with key: String) -> JSON {
        guard let dict = self[key] as? JSON else {
            Logger.error("getting JSON"); return [:]
        }
        return dict
    }
    
    func getBoolType(with key: String) -> Bool {
        return (self[key] as? String ?? "0") == "1" ? true : false
    }
    /// fetch Relation type and turn its to array
    func getRelationList(type: Relation.RelationType, with key: String) -> [Relation] {
        guard let dictArray = self[key] as? [JSON] else { return [] }
        return dictArray.map { Relation(type: type, from: $0) }
    }
    /// fetch MediaFile type and turn its to array
    func getMediaFileList(with key: String) -> [MediaFile] {
        guard let dictArray = self[key] as? [JSON] else { return [] }
        return dictArray.map { MediaFile(from: $0) }
    }
    /// fetch MediaFile type and turn its to array
    func turnToDictFromDictionaryArray(with key: String) -> JSON {
        guard let dictArray = self[key] as? [JSON] else { return [:] }
        var resultDict: JSON = [:]
        dictArray.forEach { json in
            json.forEach { resultDict[$0.key] = $0.value }
        }
        return resultDict
    }
}
