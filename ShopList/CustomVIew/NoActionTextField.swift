//
//  NoActionTextField.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import Foundation
import UIKit

class NoActionTextField: UITextField {
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
   
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
    }
}
