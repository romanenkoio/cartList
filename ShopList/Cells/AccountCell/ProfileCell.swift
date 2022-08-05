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
        cameraImage.isHidden = !isEdit
        mailField.isHidden = !isEdit
        mailLabel.isHidden = isEdit
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            
            self.cameraImage.alpha = self.isEdit ? 0.5 : 0
            self.mailField.alpha = self.isEdit ? 1 : 0
            self.mailLabel.alpha = self.isEdit ? 0 : 1
        }
    }
}
