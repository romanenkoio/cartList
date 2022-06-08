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
   
//    override func caretRect(for position: UITextPosition) -> CGRect {
//        return CGRect.zero
//    }
   
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
   
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         return false
    }
}
