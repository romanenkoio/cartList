//
//  SLAppEnvironment.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.07.22.
//

import Foundation
import Firebase

struct SLAppEnvironment {
    static private let dbUrl = "https://cartlist-8adbe-default-rtdb.europe-west1.firebasedatabase.app/"
    static let reference = Database.database(url: SLAppEnvironment.dbUrl).reference()
    
    enum DataBaseChilds: String {
        case users = "users"
    }
    
    enum ChildValues: String {
        case login
        case password
    }
}
