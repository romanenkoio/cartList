//
//  RealmManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import RealmSwift

final class RealmManager {
    static private let realm = try! Realm()
    
    class func beginWrite() {
        realm.beginWrite()
    }
    
    class func commitWrite() {
        try? realm.commitWrite()
    }
    
    class func read<T: Object>(type: T.Type) -> [T] {
        return Array(realm.objects(T.self))
    }
    
    class func write<T: Object>(object: T) {
        try? realm.write({
            realm.add(object)
        })
    }
    
    class func delete<T: Object>(object: T) {
        try? realm.write({
            realm.delete(object)
        })
    }
    
    class func removeList(_ list: SLRealmList) {
        let products = read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id })
        
        try? realm.write({
            for product in products {
                realm.delete(product)
            }
        })
        
        delete(object: list)
    }
}
