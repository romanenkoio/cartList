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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimation()
    }
    
    private func playAnimation() {
        premiumView.loopMode = .loop
        premiumView.animationSpeed = 0.5
        premiumView.play()
        premiumView.animation = Animation.named("cartAnimation")
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
