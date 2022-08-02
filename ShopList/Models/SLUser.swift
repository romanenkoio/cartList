//
//  SLUser.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import Foundation

final class SLUser: CustomDebugStringConvertible {
    var name: String?
    var email: String?
    var uid: String?
    var lists: [SLFirebaseList]? 
    
    private enum Keys: String {
        case username
        case email
        case uid
    }
    
    init(name: String? = nil, email: String? = nil, uid: String? = nil) {
        self.name = name
        self.email = email
        self.uid = uid
    }
    
    init(from dict: [String: Any], key: String) {
        self.name = dict[Keys.username.rawValue] as? String
        self.email = dict[Keys.email.rawValue] as? String
        self.uid = key
    }
    
    var debugDescription: String {
        return "\(self.name ?? "nil")\n \(self.email ?? "nil")\n \(self.uid ?? "nil")"
    }
}
