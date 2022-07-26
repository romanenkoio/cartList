//
//  ValidationTextField.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.07.22.
//

import Foundation
import UIKit

class ValidationTextField: NoActionTextField {
    var validationType: Validator.Regexp = .email
    private let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
    private var timer: Timer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addTarget(self, action: #selector(isValid), for: .allEvents)
        self.borderStyle = .none
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.25
        self.cornerRadius = 8
    }
    
    @objc func isValid() -> Bool {
        let isValid = Validator.validate(string: self.text, pattern: self.validationType) || self.text?.count == 0
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { [weak self] _ in
            isValid ? self?.validState() : self?.invalidState()
        })
        return isValid
    }
    
    func validState() {
        UIView.animate(withDuration: 2) { [weak self] in
            self?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func invalidState() {
        UIView.animate(withDuration: 2) { [weak self] in
            self?.layer.borderColor = UIColor.red.cgColor
        }
        self.shake()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
