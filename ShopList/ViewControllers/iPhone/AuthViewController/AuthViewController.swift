//
//  AuthViewController.swift
//  ShopList
//
//  Created by Andrew Moroz on 25.07.22.
//

import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
//        var signUp: Bool = true {
//        willSet {
//            if newValue {
//                confirmButton.setTitle("Вход", for: .normal)
//            } else {
//                confirmButton.setTitle("Регистрация", for: .normal)
//            }
//        }
//    }
    
    var existUser: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dismissController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//
//            if user == nil {
//
//            }
//        }
        
        if existUser {
            confirmButton.setTitle(AppLocalizationKeys.signIn.localized(), for: .normal)
        } else {
            confirmButton.setTitle(AppLocalizationKeys.registration.localized(), for: .normal)
        }
    }
    
    private func dismissController() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipe(sender:)))
        swipeDown.direction = .down
        self.backgroundView.isUserInteractionEnabled = true
        self.backgroundView.addGestureRecognizer(swipeDown)
    }
    
    @objc private func swipe(sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }

    @IBAction func confirmAction(_ sender: UIButton) {
        
        print("LOGIN:\(loginField.text)")
        guard let login = loginField.text,
              let password = passwordField.text
        else { return }
        
//        if existUser {
            
//            if (!login.isEmpty && !password.isEmpty) {
                Auth.auth().createUser(withEmail: login, password: password) { (result, error) in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let reference = Database.database(url: "https://simple-cart-list-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users")
                            reference.child(result.user.uid).updateChildValues(["login" : login, "password" : password, "lists" : ["ispinned" : false, "listName" : "", "products" : "", "sharedFor" : ""]])
                            self.dismiss(animated: true)
                        }
                    }
                }
//            }
//        } else {
//            Auth.auth().signIn(withEmail: login, password: password)
//            self.dismiss(animated: true)
//        }
        
        
//        if !login.isEmpty, !password.isEmpty {
//            Auth.auth().signIn(withEmail: login, password: password) { result, error in
//                if error == nil {
//                    if let result = result {
//                        self.dismiss(animated: true)
//                    }
//                }
//            }
//        }
    }
}

/*
 
 {
     
     guard let login = loginField.text,
           let password = passwordField.text
     else { return }
     
     if signUp {
         if !login.isEmpty, !password.isEmpty {
             Auth.auth().createUser(withEmail: login, password: password) { result, error in
                 if error == nil {
                     if let result = result {
                         print(result.user.uid)
                         let reference = Database.database().reference().child("users")
                         reference.child(result.user.uid).updateChildValues(["login" : login, "password" : password])
                         self.dismiss(animated: true)
                         
                     }
                 }
             }
         }
     } else {
         if !login.isEmpty, !password.isEmpty {
             Auth.auth().signIn(withEmail: login, password: password) { result, error in
                 if error == nil {
                     if let result = result {
                         self.dismiss(animated: true)
                     }
                 }
             }
         }
     }
 }
 
 */
