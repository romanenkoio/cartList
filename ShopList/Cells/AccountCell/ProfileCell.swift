//
//  ProfileCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.07.22.
//

import UIKit

class ProfileCell: UITableViewCell {
    static let id = String(describing: ProfileCell.self)
        
    @IBOutlet weak var mailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        mailLabel.text = KeychainManager.UID != nil ? KeychainManager.UID : "Войти в аккаунт"
    }
}
