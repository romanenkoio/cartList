//
//  Validator.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.07.22.
//

import Foundation

class Validator {
  
    enum Regexp: String {
        case coordinates = "[0-9]{1,4}\\.[0-9]{3,30}\\, [0-9]{1,4}\\.[0-9]{3,30}"
        case phone = "^(\\+375|375)(29|25|44|33)(\\d{3})(\\d{2})(\\d{2})$"
        case password = "[\\S]{6,25}"
        case email = "^[A-z0-9_.+-]+@[A-z0-9-]+(\\.[A-z0-9-]{2,})+$"
        case youtube = "(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)"
    }
    
    static func validate(string: String?, pattern: Regexp) -> Bool {
        guard let string = string else {
            return false
        }

        let passPred = NSPredicate(format:"SELF MATCHES %@", pattern.rawValue)
        return passPred.evaluate(with: string)
    }
}
