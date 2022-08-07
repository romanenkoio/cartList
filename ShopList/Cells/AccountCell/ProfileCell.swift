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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    
    var isEdit: Bool = false
    var postNewUsername: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setup()
        setupEditingStatus()

        
        SLFirManager.getUser { [weak self] _ in
            self?.setup()
        }
        
        usernameField.addTarget(self, action: #selector(textDidChange), for: .allEvents)
    }
    
    @objc func setup() {
        usernameLabel.text = DefaultsManager.username
         mailLabel.text = DefaultsManager.username
        mailField.text = DefaultsManager.username
        avatarImage.setImage(url: DefaultsManager.photoUrl)
    }
    
    @objc func textDidChange() {
        if self.usernameField.text != "" && self.usernameField.text != nil {
            postNewUsername?()
        } else {
            return
        }
    }
    
    func setupEditingStatus() {
        cameraImage.isHidden = !isEdit
        usernameField.isHidden = !isEdit
        usernameLabel.isHidden = isEdit
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let self = self else { return }
            
            self.cameraImage.alpha = self.isEdit ? 0.5 : 0
            self.usernameField.alpha = self.isEdit ? 1 : 0
            self.usernameLabel.alpha = self.isEdit ? 0 : 1
        }
    }
}
