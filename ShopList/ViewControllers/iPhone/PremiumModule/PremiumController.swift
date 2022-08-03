//
//  PremiumController.swift
//  ShopList
//
//  Created by Illia Romanenko on 15.07.22.
//

import UIKit
import Lottie

class PremiumController: UIViewController {
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var monthSubButton: UIButton!
    @IBOutlet weak var yearSubButton: UIButton!
    @IBOutlet weak var foreverSubButton: UIButton!
    
    private var timer: Timer?
    private var counter = 0
    
    var infoArray = ["Неограниченное количество списков", "Отсутствие рекламы", "Возможность закреплять списки"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLanguage()
        subscribeToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc  func updateLanguage() {
        headerLabel.text = AppLocalizationKeys.premiumInfo.localized()
        monthSubButton.setTitle(AppLocalizationKeys.premiumMonthSub.localized(), for: .normal)
        yearSubButton.setTitle(AppLocalizationKeys.premiumyYearSub.localized(), for: .normal)
        foreverSubButton.setTitle(AppLocalizationKeys.premiumyYearSub.localized(), for: .normal)
//        infoArray = AppLocalizationKeys.premiumAdvantages.localized()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }

}
