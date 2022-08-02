//
//  SLFirebaseProduct.swift
//  ShopList
//
//  Created by Andrew Moroz on 27.07.22.
//

import Foundation

class SLFirebaseProduct {
    
    var productName: String?
    var produckPkg: String?
    var productCount: Float?
    var checked = false
    var id: String?
    
    init(productName: String, produckPkg: String, productCount: Float, checked: Bool, id: String? = nil) {
        
        self.productName = productName
        self.produckPkg = produckPkg
        self.productCount = productCount
        self.checked = checked
        self.id = id
    }
    
    init(dict: [String: Any], key: String) {
        self.productName = dict["productName"] as? String
        self.produckPkg = dict["produckPkg"] as? String
        self.productCount = dict["productCount"] as? Float
        self.checked = dict["checked"] as? Bool ?? false
        self.id = key
    }
}
