//
//  SLRealmProduct.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import RealmSwift

class SLRealmProduct: Object {
    @objc dynamic var productName = ""
    @objc dynamic var produckPkg = ""
    @objc dynamic var productCount = 0.0
    @objc dynamic var ownerListID = 0
    @objc dynamic var checked = false
    @objc dynamic var productID: Int = 0
    
    convenience init(productName: String, produckPkg: String, productCount: Double, listID: Int) {
        self.init()
        self.productName = productName
        self.produckPkg = produckPkg
        self.productCount = productCount
        self.ownerListID = listID
        self.productID = (RealmManager.read(type: SLRealmProduct.self).map({ $0.productID }).max() ?? 0) + 1
    }
    
    override class func primaryKey() -> String? {
        return "productID"
    }
}
