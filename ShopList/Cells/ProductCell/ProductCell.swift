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
    
    private var indexPath: IndexPath?
    private var currentProduct: SLFirebaseProduct?
    var listID: String?
    
    var updateBlock: ((IndexPath) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeSelection))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func changeSelection() {
        guard let currentProduct = currentProduct else {
            return
        }
       
        self.currentProduct?.checked = !currentProduct.checked
        
        SLFirManager.updateProduct(currentProduct, listID: listID!)
        updateBlock?(self.indexPath!)
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
