//
//  SLUser.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import Foundation

final class SLUser {
    var isAnonimus = false
    var email: String
    
    init(isAnonimus: Bool, email: String) {
        self.isAnonimus = isAnonimus
        self.email = email
    }
}
