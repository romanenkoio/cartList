//
//  SLFirebaseList.swift
//  ShopList
//
//  Created by Andrew Moroz on 27.07.22.
//

import Foundation

class SLFirebaseList {
    
    var listName: String?
    var isPinned: Bool = false
    var products = [SLFirebaseProduct]()
    var id: String?
    var ownerid: String?
    var sharedList: Bool = false
    
    init(listName: String, isPinned: Bool, id: String? = nil) {
        self.listName = listName
        self.isPinned = isPinned
        self.id = id
    }
    
    init(dict: [String: Any], key: String) {
        self.listName = dict["listName"] as? String
        self.isPinned = dict["isPinned"] as? Bool ?? false
        self.id = key

    }
}
