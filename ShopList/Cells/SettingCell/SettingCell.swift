//
//  SettingCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit
import Firebase

class SettingCell: UITableViewCell {
    static let id = String(describing: SettingCell.self)
    
    @IBOutlet private weak var imageLabel: UIImageView!
    @IBOutlet private weak var settingLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet weak var indicator: UIImageView!
    
    var switchAction: SwitchAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = .systemGray6
    }
    
    func setupWith(_ type: SLSettingsPoint) {
        self.indicator.isHidden = type.indicator == .none
        imageLabel.image = type.image
        settingLabel.text = type.text
        switcher.isHidden = type.switcherHidden
        imageLabel.isHidden = type.imageHidden
        switcher.isOn = type.state
        self.contentView.alpha = type.isEnabled ? 1 : 0.5
    }
    
    func setupWith(_ type: ProfilePoints) {
        self.indicator.isHidden = true
        imageLabel.image = type.image
        settingLabel.text = type.text
        switcher.isHidden = true
        settingLabel.textColor = type.color
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        switchAction?(sender.isOn)
    }
}
