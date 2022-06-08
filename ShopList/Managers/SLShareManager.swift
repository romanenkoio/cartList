//
//  SLFileManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.04.22.
//

import Foundation
import UIKit

final class SLShareManager {
    private static let fileExtension = ".slf"
    private static let fileManager = FileManager.default
    
    class func shareList(_ list: SLRealmList, from: UIViewController) {
        var listText = "\(list.listName)/n"
        
        let products = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id })
        
        for product in products {
            listText += "\(product.productName)&\(product.produckPkg)&\(product.productCount)/n"
        }
        if let listData = listText.data(using: .utf8) {
            guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }
            let filePath = appSupportDir.appendingPathComponent("list\(fileExtension)").path
            if fileManager.createFile(atPath: filePath, contents: listData, attributes: nil) {
                let fileUrl = URL(fileURLWithPath: filePath)
                let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = from.view

                from.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}
