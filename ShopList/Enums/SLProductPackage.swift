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
        case .pieces:
            return AppLocalizationKeys.pieces.localized()
        case .kilograms:
            return AppLocalizationKeys.kilograms.localized()
        case .litres:
            return AppLocalizationKeys.litres.localized()
        case .package:
            return AppLocalizationKeys.package.localized()
        case .jar:
            return AppLocalizationKeys.jar.localized()
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
        case .pieces:
            return AppLocalizationKeys.piecesAbb.localized()
        case .kilograms:
            return AppLocalizationKeys.kilogramsAbb.localized()
        case .litres:
            return AppLocalizationKeys.litresAbb.localized()
        case .package:
            return AppLocalizationKeys.packageAbb.localized()
        case .jar:
            return AppLocalizationKeys.jarAbb.localized()
        }
    }
}
