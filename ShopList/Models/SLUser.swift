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
    var photoUrl: String?
    var lists: [SLFirebaseList]? 
    
    private enum Keys: String {
        case username
        case email
        case uid
        case photoUrl
    }
    
    init(name: String? = nil, email: String? = nil, uid: String? = nil, photoUrl: String? = nil) {
        self.name = name
        self.email = email
        self.uid = uid
        self.photoUrl = photoUrl
    }
    
    init(from dict: [String: Any], key: String) {
        self.name = dict[Keys.username.rawValue] as? String
        self.email = dict[Keys.email.rawValue] as? String
        self.photoUrl = dict[Keys.photoUrl.rawValue] as? String
        self.uid = key
    }
    
    var debugDescription: String {
        return "Name: \(self.name ?? "nil")\n Email: \(self.email ?? "nil")\n UID: \(self.uid ?? "nil")\n PhotoUrl: \(self.photoUrl ?? "nil")"
    }
}
