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
     
    }
    
    func setup() {
        mailLabel.text = DefaultsManager.username
        
        guard let url = URL(string: DefaultsManager.photoUrl) else { return }
        avatarImage.sd_setImage(with: url)

    }
}
