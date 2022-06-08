//
//  SLProductPackage.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation

enum SLProductPackage: CaseIterable {
    case pieces
    case kilograms
    case litres
    case package
    case jar
    
    var pkg: String {
        switch self {
        case .pieces:       return "Штуки"
        case .kilograms:    return "Килограммы"
        case .litres:       return "Литры"
        case .package:      return "Упаковки"
        case .jar:          return "Банки"
        }
    }
    
    var pkgStep: Float {
        switch self {
        case .kilograms, .litres:        return 0.5
        default:                         return 1
        }
    }
    
    var pkgAbb: String {
        switch self {
        case .pieces:           return "шт."
        case .kilograms:        return "кг."
        case .litres:           return "л."
        case .package:          return "уп."
        case .jar:              return "банки"
        }
    }
}
