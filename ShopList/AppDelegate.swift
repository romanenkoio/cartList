//
//  AppDelegate.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit
import RealmSwift
import GoogleMobileAds


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        migrateRealm()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        SLShareManager.syncronizeData()
        
        return true
    }

    private func migrateRealm() {
        let config = Realm.Configuration(schemaVersion: 4)
        Realm.Configuration.defaultConfiguration = config
    }
}

