//
//  AuthViewController.swift
//  ShopList
//
//  Created by Andrew Moroz on 25.07.22.
//

import UIKit
import Firebase

enum AuthAction {
    case login
    case registration
    case changePassword
}

class AuthViewController: UIViewController {

    @IBOutlet weak var loginField: ValidationTextField!
    @IBOutlet weak var passwordField: ValidationTextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    var type = AuthAction.login
        
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissController()
        loginField.validationType = .email
        passwordField.validationType = .password
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch type {
        case .login:
            confirmButton.setTitle(AppLocalizationKeys.signIn.localized(), for: .normal)
        case .registration:
            confirmButton.setTitle(AppLocalizationKeys.signIn.localized(), for: .normal)
        case .changePassword:
            break
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
        
        switch type {
        case .login:
            Auth.auth().createUser(withEmail: login, password: password) { (result, error) in
                if error == nil {
                    if let result = result {
                        print(result.user.uid)
                        KeychainManager.store(value: result.user.uid, for: .UID)
                        let reference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)
                        reference.child(result.user.uid).updateChildValues([SLAppEnvironment.ChildValues.login : login, SLAppEnvironment.ChildValues.password.rawValue : password])
                        self.dismiss(animated: true)
                    }
                }
            }
        case .registration:
            break
        case .changePassword:
            break
        }
   
    }
}

