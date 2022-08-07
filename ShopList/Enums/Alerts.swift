//
//  Alerts.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.04.22.
//

import Foundation
import UIKit

enum Alerts {
    case refresh
    case information(text: String)
    case mapType
    case saveCoordinate
    case share
    case deleteConfirmation
    case confirmation
    case auth
    case changeAvatar
    case deleteAvatar
    
    private var title: String? {
        switch self {
        case .refresh:              return AppLocalizationKeys.refreshTitle.localized()
        case .share:                return AppLocalizationKeys.alertShare.localized()
        case .deleteConfirmation:   return "Удалить аккаунт?"
        case .changeAvatar:         return "Выберите действие"
        case .deleteAvatar:         return "Удалить фото?"
        default:                    return nil
        }
    }
    
    private var message: String? {
        switch self {
        case .refresh:
            return AppLocalizationKeys.refresh.localized()
        case .information(let text):
            return text
        case .mapType:
            return AppLocalizationKeys.mapType.localized()
        case .saveCoordinate:
            return AppLocalizationKeys.saveCoordinate.localized()
        case .share:
            return AppLocalizationKeys.share.localized()
        case .deleteConfirmation:
            return "Действительно удалить аккаунт? Вы потяреяете все свои списки. Это действие необратимо. "
        case .confirmation:
            return "Действительно выйти?"
        case .auth, .changeAvatar:
            return nil
        case .deleteAvatar:
            return "Действительно удалить фото профиля?"
        }
    }
    
    private var style: UIAlertController.Style {
        switch self {
        case .refresh, .information, .saveCoordinate, .deleteConfirmation, .confirmation, .deleteAvatar:
            return .alert
        case .mapType, .share, .auth, .changeAvatar:
            return .actionSheet
        }
    }
    
    var controller: UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: style)
    }
}
