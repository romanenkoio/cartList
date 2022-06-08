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
    }
    
    private func setupTabBar() {
        let list = UINavigationController(rootViewController: MainListController.loadFromNib())
        let setting = UINavigationController(rootViewController: SettingsController.loadFromNib())
        let shopList = UINavigationController(rootViewController: ShopListController.loadFromNib())

        list.tabBarItem = UITabBarItem(title: "Мои списки", image: UIImage(systemName: "checklist"), tag: 0)
        setting.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gear"), tag: 2)
        shopList.tabBarItem = UITabBarItem(title: "Магазины", image: UIImage(systemName: "gear"), tag: 1)

        self.tabBar.tintColor = .mainOrange
        self.viewControllers = [list, shopList, setting]
    }

}
