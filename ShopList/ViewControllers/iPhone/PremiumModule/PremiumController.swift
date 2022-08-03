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
    @IBOutlet weak var infoLabel: UILabel!
    
    private var timer: Timer?
    private var counter = 0
    
    var infoArray = ["Неограниченное количество списков", "Отсутствие рекламы", "Возможность закреплять списки"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

}
