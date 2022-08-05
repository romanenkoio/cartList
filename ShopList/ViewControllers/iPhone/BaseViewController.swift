//
//  BaseViewController.swift
//  ShopList
//
//  Created by Illia Romanenko on 4.08.22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = UIImage(named: "clearBackground")?.alpha(0.3)
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}
