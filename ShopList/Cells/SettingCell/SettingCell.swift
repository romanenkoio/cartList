//
//  SettingCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit
import Firebase

class SettingCell: UITableViewCell {
    @IBOutlet private weak var imageLabel: UIImageView!
    @IBOutlet private weak var settingLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!
    
    var switchAction: SwitchAction?
    var registrationButtonAction: (() -> ())?
    
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
    
    
    func showAuthController(_ vc: UIViewController) {
        let authVC = AuthViewController(nibName: String(describing: AuthViewController.self), bundle: nil)
//        present(vc, animated: true)
//        self.window?.rootViewController?.present(authVC, animated: true)
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        switchAction?(sender.isOn)
    }
    
//    @IBAction func registrationAction(_ sender: UIButton) {
//
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//
//            if user == nil {
//                self.showAuthController()
//                self.registrationButtonAction?()
//            }
//        }
//        print("tttttt")
//    }
}
