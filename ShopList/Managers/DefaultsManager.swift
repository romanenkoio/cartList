//
//  DefaultsManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation

final class DefaultsManager {
    class var hours: Int {
        get {
            let morningComponent = UserDefaults.standard.value(forKey: #function) as? Int
            return morningComponent ?? 11
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var minutes: Int {
        get {
            let morningComponent = UserDefaults.standard.value(forKey: #function) as? Int
            return morningComponent ?? 0
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var autoDelete: Bool {
        get {
            let autoDelete = UserDefaults.standard.value(forKey: #function) as? Bool
            return autoDelete ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var notificationByLocation: Bool {
        get {
            let notificationByLocation = UserDefaults.standard.value(forKey: #function) as? Bool
//            return notificationByLocation ?? false
            return false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var timeNotification: Bool {
        get {
            let morningNotification = UserDefaults.standard.value(forKey: #function) as? Bool
            return morningNotification ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var separateProducts: Bool {
        get {
            let separateProsucts = UserDefaults.standard.value(forKey: #function) as? Bool
            return separateProsucts ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var isFirstProductLaunch: Bool {
        get {
            let isFirstProductLaunch = UserDefaults.standard.value(forKey: #function) as? Bool
            return isFirstProductLaunch ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var isFirstSettingsLaunch: Bool {
        get {
            let isFirstListLaunch = UserDefaults.standard.value(forKey: #function) as? Bool
            return isFirstListLaunch ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var isFirstListLaunch: Bool {
        get {
            let isFirstListLaunch = UserDefaults.standard.value(forKey: #function) as? Bool
            return isFirstListLaunch ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var isMapListLaunch: Bool {
        get {
            let isMapListLaunch = UserDefaults.standard.value(forKey: #function) as? Bool
            return isMapListLaunch ?? true
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var baseRadius: Int {
        get {
            let baseRadius = UserDefaults.standard.value(forKey: #function) as? Int
            return baseRadius ?? 100
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var userLanguage: String {
        get {
            let userLanguage = UserDefaults.standard.value(forKey: #function) as? String
            return userLanguage ?? (Locale.current.languageCode ?? "en")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var lainchCount: Int {
        get {
            let lainchCount = UserDefaults.standard.value(forKey: #function) as? Int
            return lainchCount ?? 0
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    class var pinnedLists: [String] {
        get {
            let pinnedLists = UserDefaults.standard.value(forKey: #function) as? [String]
            return pinnedLists ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
