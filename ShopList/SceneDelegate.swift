//
//  SceneDelegate.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit
import GoogleMaps
import Firebase
import EasyTipView
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    var currentViewController: UIViewController? {
        return findTopController()
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        FirebaseApp.configure()
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        GMSServices.provideAPIKey("AIzaSyAS6qgX2yi3HcDVg_Um0ScpBP4wkp3R5pM")
        setupEasyTipView()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .mainOrange
        NotificationManager.requestAuthorisation()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:
//            window?.rootViewController = BaseTabBarController()
//        case .pad:
//            window?.rootViewController = MainPadController.loadFromNib()
//        @unknown default: break
//        }
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
    
    private func setupEasyTipView() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.foregroundColor = .black
        preferences.drawing.backgroundColor = .white
        preferences.drawing.borderColor = .mainOrange
        preferences.drawing.borderWidth = 1
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.any
        
        EasyTipView.globalPreferences = preferences
    }
    
    private func setupNavigationBar() {
        if #available(iOS 15, *) {
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
        }
    }
}
