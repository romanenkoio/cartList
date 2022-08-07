//
//  UNNotificationName+Extension.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.04.22.
//

import Foundation

extension Notification.Name {
    static let listWasImported = Notification.Name(rawValue: "listWasImported")
    static let languageChange = Notification.Name(rawValue: "LanguageChange")
    static let imageUpdated = Notification.Name(rawValue: "ImageUpdated")
    static let imageRemoved = Notification.Name(rawValue: "ImageRemoved")

}
