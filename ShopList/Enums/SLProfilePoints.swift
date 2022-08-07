//
//  ProfilePoints.swift
//  ShopList
//
//  Created by Andrew Moroz on 4.08.22.
//

import Foundation
import UIKit

enum SLProfilePoints {
    case picture
    
    case name
    case accountStatus
    case listCounts
    
    case edit
    case removeAccount
    case logout
    
    case saveChanges
    case cancelChanges
    
    static func getMenu(edit: Bool) -> [[SLProfilePoints]] {
        if edit {
            return [[.picture], [.saveChanges, .cancelChanges]]
        } else {
            return [[.picture], [.name, .accountStatus], [.edit, .removeAccount, .logout]]
        }
    }
    
    var text: String {
        switch self {
        case .picture:          return ""
        case .name:             return DefaultsManager.email
        case .accountStatus:    return "\(AppLocalizationKeys.accountType.localized()) базовый"
        case .listCounts:       return "\(AppLocalizationKeys.listsCount.localized()) 2/6"
        case .edit:             return AppLocalizationKeys.editProfile.localized()
        case .removeAccount:    return AppLocalizationKeys.deleteProfile.localized()
        case .logout:           return AppLocalizationKeys.logOut.localized()
        case .saveChanges:      return AppLocalizationKeys.saveChanges.localized()
        case .cancelChanges:    return AppLocalizationKeys.cancelChanges.localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .picture:          return nil
        case .name:             return UIImage(systemName: "envelope.circle.fill")
        case .accountStatus:    return UIImage(systemName: "star.circle.fill")
        case .listCounts:       return UIImage(systemName: "list.bullet.circle.fill")
        case .edit:             return UIImage(systemName: "pencil.circle.fill")
        case .removeAccount:    return UIImage(systemName: "trash.circle.fill")
        case .logout:           return UIImage(systemName: "chevron.backward.circle.fill")
        case .saveChanges:      return UIImage(systemName: "checkmark.circle.fill")
        case .cancelChanges:    return UIImage(systemName: "x.circle.fill")
        }
    }
    
    var tint: UIColor {
        switch self {
        case .picture:
            return .systemGreen
        case .name:
            return .systemBlue
        case .accountStatus:
            return .systemYellow

        case .listCounts, .saveChanges:
            return .systemGreen

        case .edit:
            return .systemGreen

        case .removeAccount:                    return .red
        case .logout, .cancelChanges:           return .red

        }
    }
    
    var color: UIColor {
        switch self {
        case .removeAccount, .logout, .cancelChanges:
            return .red
        
        default:
            return .black
        }
    }
}
