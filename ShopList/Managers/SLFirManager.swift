//
//  SLFirManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import Foundation
import Firebase

final class SLFirManager {
    static func auth(type: AuthAction, email: String, password: String, successBlock: BoolResultBlock?) {
        switch type {
        case .login:
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard let result = result  else {
                    successBlock?(false)
                    return
                }
                
                KeychainManager.store(value: result.user.uid, for: .UID)
                successBlock?(true)
            }
            
        case .registration:
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                guard let result = result  else {
                    successBlock?(false)
                    return
                }
                
                KeychainManager.store(value: result.user.uid, for: .UID)

                let reference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)
                reference.child(result.user.uid).updateChildValues(["email" : email, "password" : password])
                successBlock?(true)
            }
        case .changePassword:
            break
        }
       
    }
}
