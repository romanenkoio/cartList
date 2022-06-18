//
//  ImportManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.04.22.
//

import Foundation
import UIKit

class ImportManager {
    class func importList(fileURL: URL) {
        let alert = Alerts.information(text: AppLocalizationKeys.importLists.localized()).controller
        
        let okAction = UIAlertAction(title: AppLocalizationKeys.yes.localized(), style: .default) { _ in
            guard let data = try? Data(contentsOf: fileURL) else { return }
            
            let textData = String(decoding: data, as: UTF8.self)
            
            var textArray = textData.components(separatedBy: "/n")
            let list = SLRealmList(listName: textArray[0])
            textArray.remove(at: 0)
            
            textArray = textArray.filter({ !$0.isEmpty || $0 != "/n"})
          
            for text in textArray {
                guard !text.isEmpty else { continue }
                let components = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "&")
                RealmManager.write(object: SLRealmProduct(productName: components[0], produckPkg: components[1], productCount: Double(components[2])!, listID: list.id))
            }
            RealmManager.write(object: list)
            NotificationCenter.default.post(name: .listWasImported, object: nil)
        }
        
        let cancel = UIAlertAction(title: AppLocalizationKeys.cancel.localized(), style: .cancel)
        alert.addAction(cancel)
        alert.addAction(okAction)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.currentViewController?.present(alert, animated: true)
     
    }
}
