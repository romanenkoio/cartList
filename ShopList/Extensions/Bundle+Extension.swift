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
            let path = Bundle.main.path(forResource: UserDefaults.standard.value(forKey: "userLanguage") as? String ?? Languages.ru.rawValue, ofType: "lproj")
            bundle = Bundle(path: path!)
        }

        return bundle
    }

    static func setLanguage(lang: String) {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        bundle = Bundle(path: path!)
        UserDefaults.standard.set(lang, forKey: "userLanguage")
        NotificationCenter.default.post(name: NSNotification.Name("LanguageChange"), object: nil)
    }
}
