//
//  SLFirManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import Foundation
import Firebase

final class SLFirManager {
    static let authReference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)
    
    static func auth(type: AuthAction, name: String?, email: String, password: String, successBlock: BoolResultBlock?) {
        switch type {
        case .login:
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard result != nil  else {
                    successBlock?(false)
                    return
                }
                
                successBlock?(true)
            }
            
        case .registration:
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                guard let result = result  else {
                    successBlock?(false)
                    return
                }
                
                authReference.child(result.user.uid).updateChildValues(["name" : name, "email" : email, "password" : password])
                successBlock?(true)
            }
        case .changePassword:
            break
        }
    }
    
    static func authAsAnonimus(successBlock: BoolResultBlock?) {
        Auth.auth().signInAnonymously { result, error in
            guard result != nil  else {
                successBlock?(false)
                return
            }
            successBlock?(true)
        }
    }
    
    static func getUser(result: ((SLUser?) -> ())? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { result?(nil); return; }
        
        let query = Database.database().reference().child("users/\(uid)/username")
        
        query.observeSingleEvent(of: .value) { snapshot in
            guard let name = snapshot.value as? String else { result?(nil); return; }
            KeychainManager.store(value: name, for: .username)
            result?(SLUser(name: name))
        }
    }
    
    static func updateUsername(newName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let listsRef = Database.database().reference().child("users/\(uid)")
        listsRef.updateChildValues(["username" : newName])
    }
    
    static func createList(listName: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let listsRef = Database.database().reference().child("users/\(uid)/lists").childByAutoId()
        listsRef.setValue(["listName" : listName, "isPinned" : false])
    }
    
    static func addProductToList(_ listID: String, product: SLFirebaseProduct) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let listsRef = Database.database().reference().child("users/\(uid)/lists/\(listID)/products").childByAutoId()
        listsRef.setValue(["productName" : product.productName, "produckPkg" : product.produckPkg, "productCount" : product.productCount, "checked" : false])
    }
    
    static func loadLists(success: (([SLFirebaseList]) -> ())?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let database = Database.database().reference()
        let query = database.child("users/\(uid)/lists").queryOrderedByKey()

        var lists = [SLFirebaseList]()
        query.observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children.allObjects {
                
                if let object = child as? DataSnapshot, let value = object.value as? [String : Any] {
                    let item = SLFirebaseList(listName: value["listName"] as! String, isPinned: value["isPinned"] as! Bool, id: object.key)
                    if let productsDict = value["products"] as? [String : Any] {
                        
                        for productItem in productsDict {
                            let key = productItem.key
                            if let values = productItem.value as? [String : Any] {
                            let product = SLFirebaseProduct(productName: values["productName"] as! String, produckPkg: values["produckPkg"] as! String, productCount: values["productCount"] as! Float, checked: values["checked"] as! Bool, id: key)
                                item.products.append(product)
                            }
                        }
                       
                    }
                    lists.append(item)
                }
            }
            success?(lists)
        }
    }
    
    static func loadList(_ id: String?, success: ((SLFirebaseList) -> ())?) {
        guard let id = id else { return }
        loadLists { lists in
            guard let list = lists.filter({ $0.id == id }).first else {
                return
            }
            success?(list)
        }
    }
    
    static func updateProduct(_ product: SLFirebaseProduct, listID: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let listsRef = Database.database().reference().child("users/\(uid)/lists/\(listID)/products/\(product.id!)")
        listsRef.setValue(["productName" : product.productName, "produckPkg" : product.produckPkg, "productCount" : product.productCount, "checked" : product.checked])
    }
    
    static func updateList(_ list: SLFirebaseList) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let listsRef = Database.database().reference().child("users/\(uid)/lists/\(list.id!)")
        listsRef.updateChildValues(["isPinned" : list.isPinned])
    }
    
    static func removeProduct(_ product: SLFirebaseProduct, listID: String, success: BoolResultBlock?) {
        guard let uid = Auth.auth().currentUser?.uid else { success?(false); return; }

        let listsRef = Database.database().reference().child("users/\(uid)/lists/\(listID)/products/\(product.id!)")
        listsRef.removeValue { error, result in
            guard error == nil else {
                success?(false)
                return
            }
            
            success?(true)
        }
    }
    
    static func removeList(_ list: SLFirebaseList, success: BoolResultBlock?) {
        guard let uid = Auth.auth().currentUser?.uid else { success?(false); return; }

        let listsRef = Database.database().reference().child("users/\(uid)/lists/\(list.id!)")
        listsRef.removeValue { error, result in
            guard error == nil else {
                success?(false)
                return
            }
            
            success?(true)
        }
    }
}

