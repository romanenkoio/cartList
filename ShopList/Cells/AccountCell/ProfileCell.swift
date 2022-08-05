//
//  ProfileCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import UIKit

class ProfileCell: UITableViewCell {
    static let id = String(describing: ProfileCell.self)
        
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var constraintWithoutStack: NSLayoutConstraint!
    @IBOutlet weak var constraintWithStack: NSLayoutConstraint!
    
    var isEdit: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setup()
        changeConstraints()
        
        SLFirManager.getUser { [weak self] _ in
            self?.setup()
        }
    }
    
    @objc func setup() {
        mailLabel.text = DefaultsManager.username
        avatarImage.setImage(url: DefaultsManager.photoUrl)
    }
    
    func changeConstraints() {
        if isEdit {
            cameraImage.isHidden = false
            mailField.isHidden = false
            mailLabel.isHidden = true
            UIView.animate(withDuration: 0.4) {
                self.cameraImage.alpha = 0.5
                self.mailField.alpha = 1
                self.mailLabel.alpha = 0
            }
            cameraImage.isHidden = false
            mailField.isHidden = false
            mailLabel.isHidden = true
        } else {
            cameraImage.isHidden = true
            mailField.isHidden = true
            mailLabel.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.cameraImage.alpha = 0
                self.mailField.alpha = 0
                self.mailLabel.alpha = 1
            }
        }
    }
    /*
     func changeConstraints() {
         if isEdit {
             constraintWithoutStack.isActive = false
             constraintWithStack.isActive = true
             buttonsStack.isHidden = false
             cameraImage.isHidden = false
             mailField.isHidden = false
             mailLabel.isHidden = true
         } else {
             constraintWithoutStack.isActive = true
             constraintWithStack.isActive = false
             buttonsStack.isHidden = true
             cameraImage.isHidden = true
             mailField.isHidden = true
             mailLabel.isHidden = false
         }
     }
     */
}
