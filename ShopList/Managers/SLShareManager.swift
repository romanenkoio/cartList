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
    
    class func shareList(_ list: SLFirebaseList, from: UIViewController) {
        var listText = "\(list.listName)/n"
        
        for product in list.products {
            listText += "\(product.productName)&\(product.produckPkg)&\(product.productCount)/n"
        }
        if let listData = listText.data(using: .utf8) {
            guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }
            let filePath = appSupportDir.appendingPathComponent(FileExtension.list.rawValue).path
            if fileManager.createFile(atPath: filePath, contents: listData, attributes: nil) {
                let fileUrl = URL(fileURLWithPath: filePath)
                let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = from.view
                
                from.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    private class func getFileUrl(with fileExtension: FileExtension, content: Data) -> URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        let filePath = appSupportDir.appendingPathComponent("\(fileExtension.rawValue)").path
        guard fileManager.createFile(atPath: filePath, contents: content, attributes: nil) else { return nil }
        return URL(fileURLWithPath: filePath)
    }
}
