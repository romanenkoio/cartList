//
//  SLFirManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import Foundation
import Firebase
import UIKit
import FirebaseStorage

final class SLFirManager {
    static let authReference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)
    
    static func getUser(result: ((SLUser?) -> ())? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { result?(nil); return; }
        
        let query = Database.database().reference().child("users/\(uid)")
        
        query.observe(.value) { snapshot in
            guard let userInfo = snapshot.value as? [String : Any] else { result?(nil); return; }
            
            let user = SLUser(from: userInfo, key: snapshot.key)
            if let name = user.name {
                DefaultsManager.username = name
            }
            
            if let photoURL = user.photoUrl {
                DefaultsManager.photoUrl = photoURL
            }
            
            DefaultsManager.email = user.email!
            
            result?(user)
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

        let listRef = Database.database().reference().child("sharedForUser/\(user)").child(list.id!)
        listRef.updateChildValues(["id": user])
    }
    
    static func userByEmail(_ email: String, success: ((SLUser) -> ())?, fail: VoidBlock?) {
        guard ((Auth.auth().currentUser?.uid) != nil) else { return }
        let ref = Database.database().reference().child("users").queryOrdered(byChild: "email")
        ref.observeSingleEvent(of: .value) { data in
            var users = [SLUser]()
            
            if let dict = data.value as? [String: Any] {
                for item in dict {
                    if let itemDict = item.value as? [String: Any]  {
                        let user = SLUser(from: itemDict, key: item.key)
                        users.append(user)
                    }
                }
                guard let user = users.filter({ $0.email == email }).first else {
                    fail?()
                    return
                }
                success?(user)
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
    
    @discardableResult
    static func loadLists(success: (([SLFirebaseList]) -> ())?) -> DatabaseQuery? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        let ref = Database.database().reference().child("lists").queryOrdered(byChild: "owner").queryEqual(toValue: uid)
        
       
        ref.observe(.value) { snapshot in
            var lists = [SLFirebaseList]()
            guard let listsDict = snapshot.value as? [String : Any] else {
                success?([])
                return
            }
            
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
            loadSharedLists { sharedLists in
                success?(lists + sharedLists)
            }
        }
        return ref
    }
    
    static  func loadSharedLists(success: (([SLFirebaseList]) -> ())?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("sharedForUser/\(uid)")
        
        ref.observe(.value) { sharedSnapshot in
            if let listsDict = sharedSnapshot.value as? [String : Any] {
                var keys = [String]()
                
                listsDict.forEach { key, value in
                    keys.append(key)
                }
                
                let allLists = Database.database().reference().child("lists")
                allLists.observe(.value) { allListsSnapshot in
                    
                    var lists = [SLFirebaseList]()
                    guard let listsDict = allListsSnapshot.value as? [String : Any] else {
                        success?([])
                        return
                    }
                    
                    for child in listsDict  {
                        if keys.contains(child.key) {
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
                    }
                    success?(lists)
                    
                }
            } else {
                success?([])
            }
        }
    }
    
    static func getLastListKey(success: ((String) -> ())?) {
        Database.database().reference().child("lists").queryLimited(toLast: 1).observeSingleEvent(of: .value) { snapshot in
            guard let productsDict = snapshot.value as? [String : Any] else { return }
            
            productsDict.forEach { key, value in
                success?(key)
            }
          
        }
    }
    
    static func loadList(id: String, success: (([SLFirebaseProduct]) -> ())?) {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
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
    
    static func uploadPhoto(image: UIImage, success: ( (Bool) -> ())? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storage = Storage.storage().reference().child("images/\(uid).jpg")
        guard let imageData = image.resizeImage(targetSize: CGSize(width: 200, height: 200))?.jpegData(compressionQuality: 1) else { return }
        
        storage.putData(imageData, metadata: nil) { metadata, error in
            storage.downloadURL { url, error in
                guard let url = url else {
                    return
                }
                
                let listsRef = Database.database().reference().child("users/\(uid)")
                listsRef.updateChildValues(["photoUrl" : url.absoluteString])
                success?(true)
                NotificationCenter.default.post(name: .imageUpdated, object: nil)
            }
        }
    }
}
