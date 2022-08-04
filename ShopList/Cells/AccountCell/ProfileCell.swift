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
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var mailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setup()
        
        SLFirManager.getUser { [weak self] _ in
            self?.setup()
        }
    }
    
    @objc func setup() {
        mailLabel.text = DefaultsManager.username
        avatarImage.setImage(url: DefaultsManager.photoUrl)
    }
}
