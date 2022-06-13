//
//  String+Extension.swift
//  ShopList
//
//  Created by Alina Karpovich on 13.06.22.
//

import Foundation
extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localization", bundle: Bundle.localizedBundle(), value: self, comment: self)
    }
}
