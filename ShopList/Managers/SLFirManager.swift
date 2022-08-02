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
                
                authReference.child(result.user.uid).updateChildValues(["name" : name ?? "", "email" : email, "password" : password])
                successBlock?(true)
            }
        case .changePassword:
            break
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
        let listsRef = Database.database().reference().child("lists/").childByAutoId()
        listsRef.setValue(["listName" : listName, "owner": uid])
    }
    
    static func shareListByEmail(_ list: SLFirebaseList, for user: String) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }

        let listRef = Database.database().reference().child("lists/\(list.id!)").child("sharedFor").childByAutoId()
        listRef.updateChildValues(["id": user])
    }
    
    static func userByEmail(_ email: String, success: ((SLUser) -> ())?, fail: VoidBlock?) {
        guard ((Auth.auth().currentUser?.uid) != nil) else { return }
        let ref = Database.database().reference().child("users").queryOrdered(byChild: "email")
        ref.observeSingleEvent(of: .value) { data in
            if let dict = data.value as? [String: Any] {
                for item in dict {
                    if let itemDict = item.value as? [String: Any]  {
                        let user = SLUser(from: itemDict, key: item.key)
                        if user.email == email {
                            success?(user)
                        }
                    }
                }
            } else {
                fail?()
            }
        }
        ref.removeAllObservers()
    }
    
    static func addProductToList(_ listID: String, product: SLFirebaseProduct) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }

        let listsRef = Database.database().reference().child("lists/\(listID)/products").childByAutoId()
        listsRef.setValue(["productName" : product.productName!, "produckPkg" : product.produckPkg!, "productCount" : product.productCount!, "checked" : false, "listID": listID])
    }
    
    static func loadLists(success: (([SLFirebaseList]) -> ())?) -> DatabaseQuery? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        let ref = Database.database().reference().child("lists").queryOrdered(byChild: "owner").queryEqual(toValue: uid)
        
       
        ref.observe(.value) { snapshot in
            var lists = [SLFirebaseList]()
            guard let listsDict = snapshot.value as? [String : Any] else { return }
            for child in listsDict  {
                let list = SLFirebaseList(dict: child.value as! [String: Any], key: child.key)
                lists.append(list)
                
                if let products = child.value as? [String: Any], let dict = products["products"] as? [String: Any] {
                    dict.forEach { key, value in
                        guard let productInfoDict = value as? [String : Any] else { return }
                        let product = SLFirebaseProduct(dict: productInfoDict, key: key)
                        list.products.append(product)
                    }
                }
            }
            success?(lists)
        }
        return nil
    }
    
    static func loadList(id: String, success: (([SLFirebaseProduct]) -> ())?) {
        let productRef = Database.database().reference().child("lists/\(id)")
        productRef.observe(.value) { productSnapshot in
            var products = [SLFirebaseProduct]()
            guard let productsDict = productSnapshot.value as? [String : Any], let productInfo = productsDict["products"] as? [String : Any] else { return }
           
            productInfo.forEach { key, value in
                guard let productInfo = value as? [String : Any] else { return }
                let product = SLFirebaseProduct(dict: productInfo, key: key)
                products.append(product)
            }
            success?(products)
        }
    }
    
    static func updateProduct(_ product: SLFirebaseProduct, listID: String) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        guard let id = product.id else { return }
        
        let listsRef = Database.database().reference().child("lists/\(listID)/products/\(id)")
        listsRef.updateChildValues(["checked": product.checked])
    }
    
    static func removeProduct(_ product: SLFirebaseProduct, listID: String, success: BoolResultBlock? = nil) {
        guard (Auth.auth().currentUser?.uid) != nil else { success?(false); return; }

        let listsRef = Database.database().reference().child("lists/\(listID)/products/\(product.id!)")
        listsRef.removeValue { error, result in
            guard error == nil else {
                success?(false)
                return
            }
            
            success?(true)
        }
    }
    
    static func removeList(_ list: SLFirebaseList, success: BoolResultBlock?) {
        guard (Auth.auth().currentUser?.uid) != nil else { success?(false); return; }

        let listsRef = Database.database().reference().child("lists/\(list.id!)")
        listsRef.removeValue { error, result in
            guard error == nil else {
                success?(false)
                return
            }
            
            success?(true)
        }
    }
}

