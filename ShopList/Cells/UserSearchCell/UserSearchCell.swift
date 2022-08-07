//
//  UserSearchCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 29.07.22.
//

import UIKit
import SkeletonView

class UserSearchCell: UITableViewCell {
    static let id = String(describing: UserSearchCell.self)
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var removeUserButton: UIButton!
    var userID: String?
    var listID: String?
    var removeBlock: ((String) -> ())?
    var recentUser: SLUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        usernameLabel.isSkeletonable = true
        avatarImage.isSkeletonable = true
    }

    func setupWith(user: SLUser, isManage: Bool) {
        if let name = user.name {
            usernameLabel.text = name
        }
        avatarImage.setImage(url: user.photoUrl)
        userID = user.uid
        removeUserButton.isHidden = !isManage
    }
    
    func setupWith(userID: String) {
        self.usernameLabel.showAnimatedSkeleton()
        self.avatarImage.showAnimatedSkeleton()
        removeUserButton.isHidden = true
        
        SLFirManager.getUser(id: userID) { [weak self] user in
            guard let user = user else { return }
            self?.recentUser = user
            self?.setupWith(user: user, isManage: false)
            self?.usernameLabel.hideSkeleton()
            self?.avatarImage.hideSkeleton()
        }
    }
    
    @IBAction func removeUserAction(_ sender: Any) {
        guard let userID = userID, let listID = listID else {
            return
        }

        SLFirManager.removeUserFromList(listID: listID, userID: userID) { [weak self] success in
            if success {
                self?.removeBlock?(userID)
            }
        }
    }
}
