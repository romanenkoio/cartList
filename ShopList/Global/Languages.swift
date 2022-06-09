//
//  Languages.swift
//  ShopList
//
//  Created by Illia Romanenko on 9.06.22.
//

import Foundation

enum Languages: String {
    case ru = "Русский"
    case en = "English"
    
    static func getFullLanguageName(code: String) -> String {
        switch code {
        case "ru":
            return ru.rawValue
        default:
            return en.rawValue
        }
    }
}
