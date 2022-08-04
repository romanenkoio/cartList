//
//  CustomLaunchScreen.swift
//  ShopList
//
//  Created by Andrew Moroz on 4.08.22.
//

import UIKit

class CustomLaunchScreen: BaseViewController {

    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var fourthImage: UIImageView!
    @IBOutlet weak var fifthImage: UIImageView!
    @IBOutlet weak var sixthImage: UIImageView!
    @IBOutlet weak var firstImageGreen: UIImageView!
    
    @IBOutlet weak var firstOldConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdOldConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthOldConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondOldConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthOldConstraint: NSLayoutConstraint!
    @IBOutlet weak var sixthOldConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstNewConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdNewConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthNewConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondNewConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthNewConstraint: NSLayoutConstraint!
    @IBOutlet weak var sixthNewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoAnimation()
    }

    private func logoAnimation() {
        self.firstNewConstraint.isActive = true
        self.firstOldConstraint.isActive = false
        self.sixthNewConstraint.isActive = true
        self.sixthOldConstraint.isActive = false
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.curveEaseOut]) {
            self.view.layoutIfNeeded()
        }
        
        self.thirdNewConstraint.isActive = true
        self.thirdOldConstraint.isActive = false
        self.fourthNewConstraint.isActive = true
        self.fourthOldConstraint.isActive = false
        
        UIView.animate(withDuration: 0.6, delay: 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.curveEaseOut]) {
            self.view.layoutIfNeeded()
        }
        
        self.fifthNewConstraint.isActive = true
        self.fifthOldConstraint.isActive = false
        self.secondNewConstraint.isActive = true
        self.secondOldConstraint.isActive = false
        
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.curveEaseOut]) {
            self.view.layoutIfNeeded()
        } completion: { finished in
            self.firstImageGreen.isHidden = false
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                self.firstImageGreen.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.firstImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.secondImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.thirdImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.fourthImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.fifthImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.sixthImage.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                self.view.layoutIfNeeded()
            } completion: { finished in
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                    self.firstImageGreen.alpha = 1
                    self.firstImageGreen.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.firstImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.secondImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.thirdImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.fourthImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.fifthImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.sixthImage.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    self.view.layoutIfNeeded()
                } completion: { finished in
                    self.firstImage.alpha = 0
                    UIView.animate(withDuration: 0.3, delay: 0.4) {
                        self.firstImageGreen.alpha = 0
                        self.secondImage.alpha = 0
                        self.thirdImage.alpha = 0
                        self.fourthImage.alpha = 0
                        self.fifthImage.alpha = 0
                        self.sixthImage.alpha = 0
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
}
