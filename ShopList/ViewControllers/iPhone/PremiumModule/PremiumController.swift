//
//  PremiumController.swift
//  ShopList
//
//  Created by Illia Romanenko on 15.07.22.
//

import UIKit
import Lottie

class PremiumController: UIViewController {
    @IBOutlet weak var premiumView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func playAnimation() {
        premiumView.loopMode = .playOnce
        premiumView.animationSpeed = 0.5
        premiumView.animation = Animation.named("premium")
//        products.count > 0 ? animationView.stop() : animationView.play()
       
    }
    
    private func changeIcon(to name: String?) {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }
        
        UIApplication.shared.setAlternateIconName(name) { (error) in
            if let error = error {
                print("App icon failed to due to \(error.localizedDescription)")
            } else {
                print("App icon changed successfully.")
            }
        }
    }
}
