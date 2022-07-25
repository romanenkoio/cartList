//
//  SLSettingsPoint.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit

enum SLSettingsPoint: CaseIterable {
    case authHeader
    case signing
    case registation
    case listHeader
    case separateList
    case autoDelete
    case notificationHeader
//    case useLocationPush
//    case raduis
//    case mapPoint
    case useTimePush
    case morningTime
    case infoHeader
    case language
    case version
    
    var text: String {
        switch self {
        case .authHeader:
            return AppLocalizationKeys.authHeader.localized()
        case .signing:
            return AppLocalizationKeys.signIn.localized()
        case .registation:
            return AppLocalizationKeys.registration.localized()
//        case .useLocationPush:
//            return AppLocalizationKeys.useLocationPush.localized()
        case .useTimePush:
            return AppLocalizationKeys.useTimePush.localized()
        case .autoDelete:
            return AppLocalizationKeys.autoDelete.localized()
//        case .mapPoint:
//            return "\(AppLocalizationKeys.mapPoint.localized()): \(RealmManager.read(type: SLRealmCoordinate.self).count)"
        case .morningTime:
            return "\(AppLocalizationKeys.morningTime.localized()): \(DefaultsManager.hours):\(DefaultsManager.minutes < 10 ? "0\(DefaultsManager.minutes)" : "\(DefaultsManager.minutes)")"
        case .listHeader:
            return AppLocalizationKeys.listHeader.localized()
        case .notificationHeader:
            return AppLocalizationKeys.notificationHeader.localized()
        case .infoHeader:
            return AppLocalizationKeys.infoHeader.localized()
        case .version:
            return "\(AppLocalizationKeys.version.localized()): \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? AppLocalizationKeys.versionInfo.localized())"
        case .separateList:
            return AppLocalizationKeys.separateList.localized()
//        case .raduis:
//            return "\(AppLocalizationKeys.raduis.localized()): \(DefaultsManager.baseRadius)\(AppLocalizationKeys.radiusUnit.localized())"
        case .language:
            return "\(AppLocalizationKeys.language.localized()): \(Languages.getFullLanguageName(code: DefaultsManager.userLanguage))"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .authHeader:
            return UIImage(systemName: "person.crop.square.fill")
        case .listHeader:
            return UIImage(systemName: "square.text.square.fill")
        case .notificationHeader:
            return UIImage(systemName: "bell.square.fill")
        case .infoHeader:
            return UIImage(systemName: "info.circle.fill")
        default: return nil
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
        case .listHeader, .notificationHeader, .infoHeader:
            return false
            
        default: return true
        }
    }
    
    var state: Bool {
        switch self {
        case .autoDelete:
            return DefaultsManager.autoDelete
//        case .useLocationPush:
//            return DefaultsManager.notificationByLocation
        case .authHeader, .signing, .registation, .morningTime, .listHeader, .notificationHeader, .infoHeader, .version, .language:
            return false
        case .useTimePush:
            return DefaultsManager.timeNotification
        case .separateList:
            return DefaultsManager.separateProducts
        }
    }
    
    var indicator: UITableViewCell.AccessoryType {
        switch self {
        case .authHeader, .autoDelete, .useTimePush, .listHeader, .notificationHeader, .infoHeader, .version, .separateList:
            return .none
        
        case .signing, .registation, .morningTime, .language:
            return .disclosureIndicator
        }
    }
    
    var isEnabled: Bool {
        switch self {
//        case .mapPoint:
//            return DefaultsManager.notificationByLocation
        case .morningTime:
            return DefaultsManager.timeNotification
        default:
            return true
        }
    }
    
    var buttonsAreHidden: Bool {
        switch self {
        case .signing, .registation:
            return false
        default:
            return true
        }
    }
}
