//
//  KeychainManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.07.22.
//

import Foundation
import KeychainAccess

class KeychainManager {
    
    private static var service: String = "romanenko.shopList.com"
    
    enum Keys: String, CaseIterable {
        case UID
    }
    
    
    // MARK: - Accessors
    
    static func value(for key: Keys) -> Any? {
        if let data = try? Keychain(service: service).getData(key.rawValue) {
            let object = NSKeyedUnarchiver.unarchiveObject(with: data)
            return object
        }
        return nil
    }
    
    static func store(value: Any?, for key: Keys) {
        if value == nil {
            try? Keychain(service: service).remove(key.rawValue)
        } else {
            guard let value = value else { return }
            let data = NSKeyedArchiver.archivedData(withRootObject: value)
            try? Keychain(service: service).set(data, key: key.rawValue)
        }
    }
    
    static var UID: String? {
        get {
            return value(for: .UID) as? String ?? nil
        }
    }
    
    static func clear(key: Keys) {
        store(value: nil, for: key)
    }
    
    static func clearAll() {
        Keys.allCases.forEach {
            store(value: nil, for: $0)
        }
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
