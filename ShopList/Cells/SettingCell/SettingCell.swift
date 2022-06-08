//
//  SettingCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit

class SettingCell: UITableViewCell {
    @IBOutlet private weak var imageLabel: UIImageView!
    @IBOutlet private weak var settingLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!
    
    var switchAction: SwitchAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupWith(_ type: SLSettingsPoint) {
        self.accessoryType = type.indicator
        imageLabel.image = type.image
        settingLabel.text = type.text
        switcher.isHidden = type.switcherHidden
        imageLabel.isHidden = type.imageHidden
        switcher.isOn = type.state
        self.contentView.alpha = type.isEnabled ? 1 : 0.5
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        switchAction?(sender.isOn)
    }
}
