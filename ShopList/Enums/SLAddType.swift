//
//  SLAddType.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation

enum SLAddType: String {
    case list
    case product
    
    var localizedValue: String {
        switch self {
        case .list:
            return AppLocalizationKeys.list.localized()
        case .product:
            return AppLocalizationKeys.product.localized()
        }
    }
    
    var placeholder: String {
        switch self {
        case .list:
            return listPlaceholders[Int.random(in: 0...listPlaceholders.count - 1)]
        case .product:
            return productPlaceholders[Int.random(in: 0...productPlaceholders.count - 1)]
        }
    }
}
