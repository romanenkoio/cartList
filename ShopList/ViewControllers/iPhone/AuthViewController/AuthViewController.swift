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
        guard let login = loginField.text,
              let password = passwordField.text
        else { return }
        
                Auth.auth().createUser(withEmail: login, password: password) { (result, error) in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let reference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)
                            reference.child(result.user.uid).updateChildValues([SLAppEnvironment.ChildValues.login : login, SLAppEnvironment.ChildValues.password.rawValue : password])
                            self.dismiss(animated: true)
                        }
                    }
                }
    }
}

