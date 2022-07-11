//
//  MainListCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit

class MainListCell: UITableViewCell {
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var linkedStoreIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupWith(_ list: SLRealmList) {
//        linkedStoreIcon.isHidden = list.linkedShopID == 0
        pinImage.isHidden = !list.isPinned
        listNameLabel.text = list.listName
        cellView.backgroundColor = list.isPinned ? .mainOrange.withAlphaComponent(0.1) : .white
        let items = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id })
        itemNumberLabel.text = "\(items.filter({ $0.checked }).count)/\(items.count)"
        if items.count > 0 {
            listNameLabel.strikeThrough(items.filter({ $0.checked }).count == items.count)
        }
        cellView.layer.borderColor = UIColor.mainOrange.cgColor
    }
}
