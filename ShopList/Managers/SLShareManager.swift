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
    
//    MARK: rewrite share logic
//    class func shareList(_ list: SLRealmList, from: UIViewController) {
//       
//    }
    
    private class func getFileUrl(with fileExtension: FileExtension, content: Data) -> URL? {
        guard let appSupportDir = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        let filePath = appSupportDir.appendingPathComponent("\(fileExtension.rawValue)").path
        guard fileManager.createFile(atPath: filePath, contents: content, attributes: nil) else { return nil }
        return URL(fileURLWithPath: filePath)
    }
}
