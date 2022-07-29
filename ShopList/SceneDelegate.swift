//
//  SceneDelegate.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    var currentViewController: UIViewController? {
        return findTopController()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .mainOrange
        NotificationManager.requestAuthorisation()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        window?.rootViewController = BaseTabBarController()
        DefaultsManager.lainchCount += 1

        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else {
          return
        }
        
        ImportManager.importList(fileURL: urlContext.url)
    }
    
    private func findTopController(from _vc: UIViewController? = nil) -> UIViewController? {
        var vc: UIViewController! = _vc ?? window?.rootViewController
        if let navigationController = vc as? UINavigationController {
            vc = navigationController.visibleViewController
            if vc is UIAlertController {
                vc = navigationController.topViewController
            }
        }
        if let tabBarController = vc as? UITabBarController {
            vc = tabBarController.selectedViewController
            if let navigationController = vc as? UINavigationController {
                vc = navigationController.visibleViewController
                if vc is UIAlertController {
                    vc = navigationController.topViewController
                }
            }
        }
    
        if vc == nil {
            vc = window?.rootViewController?.presentedViewController
        }
        
        return vc
    }
    
    private func setupNavigationBar() {
        if #available(iOS 15, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
        }
    }
}
