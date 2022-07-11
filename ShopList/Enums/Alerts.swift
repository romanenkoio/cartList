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
    
    private var title: String {
        switch self {
        case .refresh:
            return AppLocalizationKeys.refreshTitle.localized()
        case .information:
            return ""
        case .mapType:
            return ""
        case .saveCoordinate:
            return ""
        case .share:
            return AppLocalizationKeys.alertShare.localized()
        }
    }
    
    private var message: String {
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
        }
    }
    
    private var style: UIAlertController.Style {
        switch self {
        case .refresh, .information, .saveCoordinate:
            return .alert
        case .mapType, .share:
            return .actionSheet
        }
    }
    
    var controller: UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: style)
    }
}
