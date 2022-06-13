//
//  Bundle+Extension.swift
//  ShopList
//
//  Created by Alina Karpovich on 13.06.22.
//

import Foundation
extension Bundle {
    
    private static var bundle: Bundle!

    static func localizedBundle() -> Bundle! {
        if bundle == nil {
            let path = Bundle.main.path(forResource: DefaultsManager.userLanguage, ofType: "lproj")
            bundle = Bundle(path: path!)
        }

        return bundle
    }

    static func setLanguage(lang: String) {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
        DefaultsManager.userLanguage = lang
        NotificationCenter.default.post(name: .languageChange, object: nil)
    }
}
