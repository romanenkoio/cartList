//
//  UIString+Extensions.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.04.22.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
