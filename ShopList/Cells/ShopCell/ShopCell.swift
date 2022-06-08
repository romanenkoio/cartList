//
//  ShopCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 1.05.22.
//

import UIKit

class ShopCell: UITableViewCell {
    static let cellID = String(describing: ShopCell.self)
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        cellView.backgroundColor = selected ? .mainOrange.withAlphaComponent(0.1) : .white
    }
    
    func setupWith(_ shop: SLRealmCoordinate) {
        shopNameLabel.text = shop.marketName
        cellView.layer.borderColor = UIColor.mainOrange.cgColor
    }
}
