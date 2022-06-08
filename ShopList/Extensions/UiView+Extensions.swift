//
//  UiView+Extensions.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: CGColor {
        set {
            self.layer.borderColor = newValue
        }
        get {
            return self.layer.borderColor ?? UIColor.mainOrange.cgColor
        }
    }
}
