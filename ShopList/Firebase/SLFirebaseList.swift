//
//  SLFirebaseList.swift
//  ShopList
//
//  Created by Andrew Moroz on 27.07.22.
//

import Foundation

class SLFirebaseList {
    
    var listName: String = ""
    var isPinned: Bool = false
//    var id: Int = 0
    
    init(listName: String, isPinned: Bool) {
        
        self.listName = listName
        self.isPinned = isPinned
//        self.id = id
    }
}
