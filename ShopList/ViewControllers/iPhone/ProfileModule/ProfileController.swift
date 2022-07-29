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
    @IBOutlet weak var allListCount: UILabel!
    @IBOutlet weak var allProductCount: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var removeAccountButton: UIButton!
    
    let authReference = SLAppEnvironment.reference.child(SLAppEnvironment.DataBaseChilds.users.rawValue)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Профиль"
        editView.alpha = 0
        logoutButton.layer.borderColor = UIColor.red.cgColor
        removeAccountButton.layer.borderColor = UIColor.red.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailLabel.text = ""
        accountStatusLabel.text = ""
        
        SLFirManager.getUser { [weak self] user in
            guard let user = user,
            let name = user.name else { return }
            self?.emailLabel.text = name
            self?.accountStatusLabel.text = ("Статус аккаунта: базовый")
        }
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
            }
        }
    }
    
    @IBAction func saveChangesAction(_ sender: UIButton) {
        guard let name = nameField.text, name.count > 0 else { return }
        SLFirManager.updateUsername(newName: name)
        closingAnimation()
    }
    
    @IBAction func cancelChangesAction(_ sender: UIButton) {
        closingAnimation()
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        openingAnimation()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
            try? Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
    }
}
