//
//  SettingsHeaderCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.04.22.
//

import UIKit

class SettingsHeaderCell: UITableViewCell {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupWith(type: SLSettingsPoint) {
        headerImageView.image = type.image
        headerLabel.text = type.text
        self.contentView.backgroundColor = .systemGray6.withAlphaComponent(0.8)
    }
}
