//
//  ProfilePoints.swift
//  ShopList
//
//  Created by Andrew Moroz on 4.08.22.
//

import Foundation
import UIKit

enum SLProfilePoints {
    case name
    case accountStatus
    case listCounts
    
    case edit
    case removeAccount
    case logout
    
    static func getMenu() -> [[SLProfilePoints]] {
        return [[.name, .accountStatus, .listCounts], [.edit, .removeAccount, .logout]]
    }
    
    var text: String {
        switch self {
        case .name:             return KeychainManager.username ?? AppLocalizationKeys.profileName.localized()
        case .accountStatus:    return "\(AppLocalizationKeys.accountType.localized()) базовый"
        case .listCounts:       return "\(AppLocalizationKeys.listsCount.localized()) 2/6"
        case .edit:             return AppLocalizationKeys.editProfile.localized()
        case .removeAccount:    return AppLocalizationKeys.deleteProfile.localized()
        case .logout:           return AppLocalizationKeys.logOut.localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .name:             return UIImage(systemName: "person.circle.fill")
        case .accountStatus:    return UIImage(systemName: "star.circle.fill")
        case .listCounts:       return UIImage(systemName: "list.bullet.circle.fill")
        case .edit:             return UIImage(systemName: "pencil.circle.fill")
        case .removeAccount:    return UIImage(systemName: "trash.circle.fill")
        case .logout:           return UIImage(systemName: "arrowshape.turn.up.left.circle.fill")
        }
    }
    
    var color: UIColor {
        switch self {
        case .removeAccount, .logout:
            return .red
        
        default:
            return .black
        }
    }
}
