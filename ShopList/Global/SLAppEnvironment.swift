//
//  SLAppEnvironment.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.07.22.
//

import Foundation

class SLAppEnvironment {
    static let dbUrl = "https://simple-cart-list-default-rtdb.europe-west1.firebasedatabase.app"
    
    enum DataBaseChilds: String {
        case users = "users"
    }
}
