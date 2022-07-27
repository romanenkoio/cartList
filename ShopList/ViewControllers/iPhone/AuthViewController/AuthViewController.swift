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
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var type = AuthAction.login
    
    var loginSuccess: VoidBlock?
        
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
            confirmButton.setTitle(AppLocalizationKeys.registration.localized(), for: .normal)
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
        spinner.startAnimating()
        
        switch type {
        case .login, .registration:
            SLFirManager.auth(type: type, email: login, password: password) { [weak self] success in
                self?.spinner.stopAnimating()
                if success {
                    self?.loginSuccess?()
                    self?.dismiss(animated: true)
                }
            }
        case .changePassword:
            break
        }
   
    }
    
    @IBAction func showPasswordAction(_ sender: UIButton) {
        passwordField.isSecureTextEntry = !passwordField.isSecureTextEntry
        sender.setImage( passwordField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye"), for: .normal)
        
    }
}

