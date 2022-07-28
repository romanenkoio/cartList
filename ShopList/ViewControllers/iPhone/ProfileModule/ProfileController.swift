//
//  ProfileController.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var accountStatusLabel: UILabel!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var newViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var oldViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var fillView: UIView!
    
    let authReference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
//        navigationController?.navigationBar.prefersLargeTitles = false
        editView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailLabel.text = ""
        accountStatusLabel.text = ""
        guard let user = Auth.auth().currentUser else {
//            let authVC = AuthViewController.loadFromNib()
//            authVC.type = .registration
//            present(authVC, animated: true)
            return
        }
        guard let email = user.email else { return }
        emailLabel.text = ("Email: \(email)")
        accountStatusLabel.text = ("Статус аккаунта: базовый")
    }
    
    private func openingAnimation() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            
            self.editView.alpha = 1
            self.editView.alpha = 1
            self.emailLabel.alpha = 0
            self.accountStatusLabel.alpha = 0
            self.view.layoutIfNeeded()

        } completion: { (finish) in
            if finish {
                
                self.oldViewConstraint.isActive = false
                self.newViewConstraint.isActive = true
                
                UIView.animate(withDuration: 0.7, delay: 0.05, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseOut]) {
                    
                    self.editView.alpha = 1
                    self.emailLabel.alpha = 0
                    self.accountStatusLabel.alpha = 0
                    self.fillView.isHidden = false
                    self.fillView.alpha = 1
                    self.view.layoutIfNeeded()

                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func closingAnimation() {
        
        self.oldViewConstraint.isActive = true
        self.newViewConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0.05) {
            
            self.fillView.alpha = 0
            self.view.layoutIfNeeded()

        } completion: { finish in
            if finish {
                
                UIView.animate(withDuration: 0.2, delay: 0.0) {
                    
                    self.fillView.isHidden = true
                    self.editView.alpha = 0
                    self.emailLabel.alpha = 1
                    self.accountStatusLabel.alpha = 1
                    self.editView.alpha = 0
                }
                
                self.view.layoutIfNeeded()
//                self.nameInputField.textField.text = ""
//                self.surnameInputField.textField.text = ""
//                self.phoneInputField.textField.text = ""
            }
        }
    }
    
    @IBAction func saveChangesAction(_ sender: UIButton) {
        
//        Auth.auth().updateCurrentUser(<#T##user: User##User#>)
//        createUser(withEmail: email, password: password) { (result, error) in
//            guard let result = result  else {
//                successBlock?(false)
//                return
//            }
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            let name = user.displayName
            var multiFactorString = "MultiFactor: "
            
            
        }
        closingAnimation()
    }
    
    @IBAction func cancelChangesAction(_ sender: UIButton) {
        
        closingAnimation()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        
        openingAnimation()
    }
    @IBAction func logoutAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            } catch {
                print(error.localizedDescription)
            }
    }
}
