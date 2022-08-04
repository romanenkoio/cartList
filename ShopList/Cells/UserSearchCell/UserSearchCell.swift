//
//  UserSearchCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 29.07.22.
//

import UIKit

class UserSearchCell: UITableViewCell {
    static let id = String(describing: UserSearchCell.self)
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setupWith(user: SLUser) {
        if let name = user.name {
            usernameLabel.text = name
        }
        avatarImage.setImage(url: user.photoUrl)
        
    }
}
