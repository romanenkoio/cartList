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
    
    func setupWith(_ list: SLFirebaseList) {
        pinImage.isHidden = !list.isPinned
        listNameLabel.text = list.listName
        cellView.backgroundColor = list.isPinned ? .mainOrange.withAlphaComponent(0.1) : .white
        cellView.layer.borderColor = UIColor.mainOrange.cgColor
        itemNumberLabel.text = "\(list.products.filter({ $0.checked }).count)/\(list.products.count)"
        if list.products.filter({ $0.checked }).count == list.products.count {
            listNameLabel.strikeThrough()
        } else {
            listNameLabel.strikeThrough(false)
        }
    }
}
