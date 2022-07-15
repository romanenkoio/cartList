//
//  CloudKitManager.swift
//  ShopList
//
//  Created by Illia Romanenko on 15.07.22.
//

import Foundation
import CloudKit

final class CloudKitManager {
    private static let containerUrl = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents", isDirectory: true)
    
    
    enum SynchroStatus {
        case synchonized
        case inProgress
        case fail
    }
    
    static func update(with dataURL: URL) {
        if let url = containerUrl {
            print(url)
            guard let icloudFile = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents").appendingPathComponent("data.aslf") else { return }
            try? FileManager.default.copyItem(at: dataURL, to: icloudFile)
        } else {
            print("Директории не существует")
        }
    }
}
