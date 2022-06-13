//
//  SLSettingsPoint.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit

enum SLSettingsPoint: CaseIterable {
    case listHeader
    case separateList
    case autoDelete
    case notificationHeader
    case useLocationPush
    case raduis
    case mapPoint
    case useTimePush
    case morningTime
    case infoHeader
    case language
    case version
    
    var text: String {
        switch self {
        case .useLocationPush:
            return "Уведомления по локации"
        case .useTimePush:
            return "Уведомления по времени"
        case .autoDelete:
            return "Удалять заполненные списки"
        case .mapPoint:
            return "Сохранённые магазины: \(RealmManager.read(type: SLRealmCoordinate.self).count)"
        case .morningTime:
            return "Время уведомления: \(DefaultsManager.hours):\(DefaultsManager.minutes < 10 ? "0\(DefaultsManager.minutes)" : "\(DefaultsManager.minutes)")"
        case .listHeader:
            return AppLocalizationKeys.listHeader.localized()
        case .notificationHeader:
            return "Настройки уведомлений"
        case .infoHeader:
            return "Общие"
        case .version:
            return "Версия: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Неизвестно")"
        case .separateList:
            return "Разделять отмеченные продукты"
        case .raduis:
            return "Радиус уведомлений: \(DefaultsManager.baseRadius)м"
        case .language:
            return "Язык: \(Languages.getFullLanguageName(code: DefaultsManager.userLanguage))"
        }
    }
    
    var image: UIImage? {
        switch self {
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
        case .useLocationPush, .useTimePush, .autoDelete, .separateList:
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
        case .useLocationPush:
            return DefaultsManager.notificationByLocation
        case .mapPoint, .morningTime, .listHeader, .notificationHeader, .infoHeader, .version, .raduis, .language:
            return false
        case .useTimePush:
            return DefaultsManager.timeNotification
        case .separateList:
            return DefaultsManager.separateProducts
        }
    }
    
    var indicator: UITableViewCell.AccessoryType {
        switch self {
        case .autoDelete, .useLocationPush, .useTimePush, .listHeader, .notificationHeader, .infoHeader, .version, .separateList:
            return .none
        
        case .mapPoint, .morningTime, .raduis, .language:
            return .disclosureIndicator
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .mapPoint, .raduis:
            return DefaultsManager.notificationByLocation
        case .morningTime:
            return DefaultsManager.timeNotification
        default:
            return true
        }
    }
}
