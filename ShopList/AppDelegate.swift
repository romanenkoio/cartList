//
//  AppDelegate.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit
import GoogleMobileAds
import Adapty
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.mainOrange
        Adapty.activate("public_live_TwxxgWmn.BnBfseyXvFQRj04pH2fO")
        Adapty.getPurchaserInfo { info, error in
            if error == nil {
                if info?.accessLevels["premium"]?.isActive == true {
                    print(info?.accessLevels["premium"])
                    print(Date())
                    DefaultsManager.isPremium = true
                } else {
                    DefaultsManager.isPremium = false
                }
            } else {
                DefaultsManager.isPremium = false
            }
        }
        Adapty.delegate = self
        return true
    }
}

extension AppDelegate: AdaptyDelegate {
    
    func didReceiveUpdatedPurchaserInfo(_ purchaserInfo: PurchaserInfoModel) {
        if purchaserInfo.accessLevels["premium"]?.isActive == true {
            DefaultsManager.isPremium = true
        } else {
            DefaultsManager.isPremium = false
        }
    }
    
    func didReceivePromo(_ promo: PromoModel) {
        
    }
}
