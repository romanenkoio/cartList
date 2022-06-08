//
//  SLRealmCoordinate.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import RealmSwift

final class SLRealmCoordinate: Object {
    @objc dynamic var marketName = ""
    @objc dynamic var lat = ""
    @objc dynamic var lon = ""
    @objc dynamic var id = 0

    convenience init(marketName: String, lat: String, lon: String) {
        self.init()
        self.marketName = marketName
        self.lat = lat
        self.lon = lon
        self.id = (RealmManager.read(type: SLRealmCoordinate.self).map({ $0.id }).max() ?? 0) + 1
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
