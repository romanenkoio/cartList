//
//  SLFileManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 27.04.22.
//

import Foundation
import UIKit

final class SLShareManager {
    private enum FileExtension: String {
        case list = "list.slf"
        case data = "data.aslf"
    }
    
    private static let fileManager = FileManager.default
    
    class func shareList(_ list: SLRealmList, from: UIViewController) {
        var listText = "\(list.listName)/n"
        
        let products = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id })
        
        for product in products {
            listText += "\(product.productName)&\(product.produckPkg)&\(product.productCount)/n"
        }
        if let listData = listText.data(using: .utf8), let fileUrl = getFileUrl(with: .list, content: listData) {
            let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = from.view
            
            from.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    class func syncronizeData() {
        var textForSharing = ""
        let lists = RealmManager.read(type: SLRealmList.self)
        
        for list in lists {
            textForSharing += "\(list.listName)/n"
            let products = RealmManager.read(type: SLRealmProduct.self).filter({ $0.ownerListID == list.id })
            for product in products {
                textForSharing += "\(product.productName)&\(product.produckPkg)&\(product.productCount)/n"
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.string(from: Date())
        textForSharing += dateFormatter.string(from: Date())
        
        if let listData = textForSharing.data(using: .utf8) {
            guard let url = getFileUrl(with: .data, content: listData) else { return }
//            CloudKitManager.upload(data: listData)
            
        }
    }
    
    private class func getFileUrl(with fileExtension: FileExtension, content: Data) -> URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        let filePath = appSupportDir.appendingPathComponent("\(fileExtension.rawValue)").path
        guard fileManager.createFile(atPath: filePath, contents: content, attributes: nil) else { return nil }
        return URL(fileURLWithPath: filePath)
    }
}
