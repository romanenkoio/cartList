//
//  OnboardingController.swift
//  ShopList
//
//  Created by Illia Romanenko on 18.08.22.
//

import UIKit

class OnboardingController: UIViewController {

    @IBOutlet weak var onboardingTextLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
        nextButton.setTitle(AppLocalizationKeys.onboardingNext.localized(), for: .normal)
        backButton.setTitle(AppLocalizationKeys.onboardingСlose.localized(), for: .normal)
    }
    
    @IBAction func backAction(_ sender: Any) {
        counter -= 1
        setupCard()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if counter == 3 {
            dismiss(animated: true)
        }
        
        counter += 1
        setupCard()
    }
    
    private func setupCard() {
        if counter <= 3 {
            onboardingTextLabel.text = AppLocalizationKeys.onboarding[counter].localized()
        }
        backButton.isHidden = counter == 0
        view.layoutIfNeeded()
        if counter == 3 {
            nextButton.setTitle(AppLocalizationKeys.onboardingСlose.localized(), for: .normal)
        }
        onboardingImage.image = UIImage(named: "onboarding_\(counter)")
    }
    
}
