//
//  SLSettingsPoint.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit
import DeviceKit

enum SLSettingsPoint: CaseIterable {
    case profile
    case separateList
    case autoDelete
    case useTimePush
    case morningTime
    case language
    case feedback
    case version
    case premium
    case biometry
    
    static func getMenu() -> [[SLSettingsPoint]] {
        return [[.profile], [.premium], [.separateList, .autoDelete], [.useTimePush, .morningTime], [.feedback, .language, .version]]
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
            // return AppLocalizationKeys.profileName
        case .premium:
            return AppLocalizationKeys.premium.localized()
        case .feedback:
            return AppLocalizationKeys.feedback.localized()
        case .biometry:
            return "Использовать FaceID"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .separateList:     return UIImage(systemName: "square.lefthalf.filled")
        case .autoDelete:       return UIImage(systemName: "trash.square.fill")
            
        case .useTimePush:      return UIImage(systemName: "bell.square.fill")
        case .morningTime:      return UIImage(systemName: "timer.square")
            
        case .feedback:         return UIImage(systemName: "envelope.circle.fill")
        case .language:         return UIImage(systemName: "bubble.left.circle")
        case .version:          return UIImage(systemName: "info.circle.fill")
           
        case .premium:          return UIImage(systemName: "star.square.fill")

        case .biometry:         return UIImage(systemName: "lock.circle.fill")
        default:                return nil
        }
    }
    
    var tint: UIColor {
        switch self {
        case .profile:
            return .white
        case .autoDelete, .separateList:
            return .systemRed
        case .useTimePush, .morningTime:
            return .systemCyan
        case .language, .version:
            return .systemGray
        case .premium:
            return .systemYellow
        case .feedback, .biometry:
            return .systemBlue
        }
    }
    
    var switcherHidden: Bool {
        switch self {
        case .useTimePush, .autoDelete, .separateList, .biometry:
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
        case .useTimePush:
            return DefaultsManager.timeNotification
        case .separateList:
            return DefaultsManager.separateProducts
        case .biometry:
            return DefaultsManager.useBiometry
        default:
            return false
        }
    }
    
    var indicator: UITableViewCell.AccessoryType {
        switch self {
        case .morningTime, .language:
            return .disclosureIndicator
        default:
            return .none
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .morningTime:  return DefaultsManager.timeNotification
        case .biometry:     return Device.current.hasBiometricSensor
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
