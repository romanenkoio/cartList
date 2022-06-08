//
//  UITableView+Extensions.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit

extension UITableView {
    func registerCellsWith(_ classes: [AnyClass]) {
        for item in classes {
            let nib = UINib(nibName: String(describing: item.self), bundle: nil)
            self.register(nib, forCellReuseIdentifier: String(describing: item.self))
        }
    }
}
