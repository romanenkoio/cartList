//
//  SLRealmListItem.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import RealmSwift

class SLRealmList: Object {
    @Persisted var listName = ""
    @Persisted(primaryKey: true) var id = 0
    @Persisted var isPinned = false
    @Persisted var linkedShopID = 0
    
    convenience init(listName: String) {
        self.init()
        self.listName = listName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.isPinned = false
        self.id = (RealmManager.read(type: SLRealmList.self).map({ $0.id }).max() ?? 0) + 1
    }
}
