//
//  SLFirebaseList.swift
//  ShopList
//
//  Created by Andrew Moroz on 27.07.22.
//

import Foundation

class SLFirebaseList {
    
    var listName: String
    var isPinned: Bool
    var products = [SLFirebaseProduct]()
    var id: String?
    
    init(listName: String, isPinned: Bool, id: String? = nil) {
        
        self.listName = listName
        self.isPinned = isPinned
        self.id = id

    }
}
