//
//  SLSettingsPoint.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit

enum SLSettingsPoint: CaseIterable {
    case profile
    case separateList
    case autoDelete
    case useTimePush
    case morningTime
    case language
    case version
    case premium
    
    static func getMenu() -> [[SLSettingsPoint]] {
        return [[.profile], [.premium], [.separateList, .autoDelete], [.useTimePush, .morningTime], [.language, .version]]
    }
    
    var text: String {
        switch self {
        case .useTimePush:
            return AppLocalizationKeys.useTimePush.localized()
        case .autoDelete:
            return AppLocalizationKeys.autoDelete.localized()
        case .morningTime:
            return "\(AppLocalizationKeys.morningTime.localized()): \(DefaultsManager.hours):\(DefaultsManager.minutes < 10 ? "0\(DefaultsManager.minutes)" : "\(DefaultsManager.minutes)")"
        case .version:
            return "\(AppLocalizationKeys.version.localized()): \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? AppLocalizationKeys.versionInfo.localized())"
        case .separateList:
            return AppLocalizationKeys.separateList.localized()
        case .language:
            return "\(AppLocalizationKeys.language.localized()): \(Languages.getFullLanguageName(code: DefaultsManager.userLanguage))"
        case .profile:
            return ""
        case .premium:
            return "Премиум подписка"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .separateList:     return UIImage(systemName: "square.line.vertical.square.fill.left")
        case .autoDelete:       return UIImage(systemName: "trash.square.fill")
            
        case .useTimePush:      return UIImage(systemName: "bell.square.fill")
        case .morningTime:      return UIImage(systemName: "timer.square")
            
        case .language:         return UIImage(systemName: "bubble.left.circle")
        case .version:          return UIImage(systemName: "info.circle.fill")
           
        case .premium:          return UIImage(systemName: "star.square.fill")

        default:                return nil
        }
    }
    
    var switcherHidden: Bool {
        switch self {
        case .useTimePush, .autoDelete, .separateList:
            return false
        default:
            return true
        }
    }
    
    var imageHidden: Bool {
        switch self {
        case .profile:  return true
        default:        return false
        }
    }
    
    var state: Bool {
        switch self {
        case .autoDelete:
            return DefaultsManager.autoDelete
        case .morningTime, .version, .language, .profile, .premium:
            return false
        case .useTimePush:
            return DefaultsManager.timeNotification
        case .separateList:
            return DefaultsManager.separateProducts
        }
    }
    
    var indicator: UITableViewCell.AccessoryType {
        switch self {
        case .profile, .autoDelete, .useTimePush, .version, .separateList, .premium:
            return .none
        
        case .morningTime, .language:
            return .disclosureIndicator
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .morningTime:  return DefaultsManager.timeNotification
        default:            return true
            
        }
    }
    
    var buttonsAreHidden: Bool {
        switch self {
        default:
            return true
        }
    }
}
