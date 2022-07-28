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
        return true
    }
}
