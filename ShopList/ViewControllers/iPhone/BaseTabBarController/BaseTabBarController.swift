//
//  BaseTabBarController.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        NotificationCenter.default.post(name: .languageChange, object: nil)
    }
    
    private func setupTabBar() {
        let list = UINavigationController(rootViewController: MainListController.loadFromNib())
        let setting = UINavigationController(rootViewController: SettingsController.loadFromNib())
        let shopList = UINavigationController(rootViewController: ShopListController.customInit(isAdding: true))

        list.tabBarItem = UITabBarItem(title: AppLocalizationKeys.myLists.localized(), image: UIImage(systemName: "checklist"), tag: 0)
        setting.tabBarItem = UITabBarItem(title: AppLocalizationKeys.settings.localized(), image: UIImage(systemName: "gear"), tag: 2)
        shopList.tabBarItem = UITabBarItem(title: AppLocalizationKeys.shops.localized(), image: UIImage(systemName: "building.2.fill"), tag: 1)

        self.tabBar.tintColor = .mainOrange
        self.viewControllers = [list, shopList, setting]
    }

}
