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
            return "Очистка списка"
        case .information:
            return ""
        case .mapType:
            return ""
        case .saveCoordinate:
            return ""
        case .share:
            return "Выберите метод"
        }
    }
    
    private var message: String {
        switch self {
        case .refresh:
            return "Действительно очистить прогресс списка?"
        case .information(let text):
            return text
        case .mapType:
            return "Выберите метод добавления"
        case .saveCoordinate:
            return "Сохранить выбранную точку?"
        case .share:
            return "При отправке файла у пользователя должно быть установлено приложение"
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
