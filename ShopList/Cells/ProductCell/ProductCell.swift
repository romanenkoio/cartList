//
//  ProductCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var pkgInfo: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    private var product: SLRealmProduct?
    private var indexPath: IndexPath?
    private var currentProduct: SLFirebaseProduct?
    
    var updateBlock: ((IndexPath) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeSelection))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func changeSelection() {
        guard let product = product else {
            return
        }
      
        RealmManager.beginWrite()
        self.product?.checked = !product.checked
        RealmManager.commitWrite()
        updateBlock?(self.indexPath!)
    }
    
    func setupWith(_ product: SLRealmProduct, _ indexPath: IndexPath) {
        self.product = product
        self.indexPath = indexPath
        mainView.borderColor = UIColor.mainOrange.cgColor
        checkImage.image = product.checked ? SLAppImages.radioCheck.image : SLAppImages.radioUnchek.image
        
        productName.strikeThrough(product.checked)
     
        pkgInfo.isHidden = product.productCount == 0
        productName.text = product.productName
        pkgInfo.text = "\(product.productCount) \(product.produckPkg)"
    }
    
    func setupWithFB(_ product: SLFirebaseProduct, _ indexPath: IndexPath) {
        self.currentProduct = product
        self.indexPath = indexPath
        mainView.borderColor = UIColor.mainOrange.cgColor
        checkImage.image = product.checked ? SLAppImages.radioCheck.image : SLAppImages.radioUnchek.image
        
        productName.strikeThrough(product.checked)
     
        pkgInfo.isHidden = product.productCount == 0
        productName.text = product.productName
        pkgInfo.text = "\(product.productCount) \(product.produckPkg)"
    }
}
