//
//  AvatarCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 4.08.22.
//

import UIKit
import SDWebImage

class AvatarCell: UITableViewCell {
    static let id = String(describing: AvatarCell.self)

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setImage()
    }
    
    func setImage() {
        nameLabel.text = DefaultsManager.username
        
        guard let url = URL(string: DefaultsManager.photoUrl) else { return }
        avatarImage.sd_setImage(with: url)

    }
}
