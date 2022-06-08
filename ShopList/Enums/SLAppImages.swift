//
//  SLAppImages.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.04.22.
//

import Foundation
import UIKit

enum SLAppImages {
    case radioCheck
    case radioUnchek
    case storeIcon
    
    var image: UIImage {
        switch self {
        case .radioCheck:
            return UIImage(named: "selected")!
        case .radioUnchek:
            return UIImage(named: "unselected")!
        case .storeIcon:
            return UIImage(named: "store")!
        }
    }
}
