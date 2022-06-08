//
//  SLAddType.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation

enum SLAddType: String {
    case list = "Название списка"
    case product = "Название продукта"
    
    var placeholder: String {
        switch self {
        case .list:
            return listPlaceholders[Int.random(in: 0...listPlaceholders.count - 1)]
        case .product:
            return productPlaceholders[Int.random(in: 0...productPlaceholders.count - 1)]
        }
    }
}
