//
//  TimeSelectPopupController.swift
//  ShopList
//
//  Created by Illia Romanenko on 26.04.22.
//

import UIKit

class TimeSelectPopupController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var saveAction: UIButton!
    @IBOutlet weak var cancelAction: UIButton!
    
    var voidBlock: VoidBlock?
    
    var dateSelectionBlock: ((Date) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.borderColor = UIColor.mainOrange.cgColor
        updateLanguage()
        subscribeToNotification()
        datePicker.locale = Locale(identifier: "en_FR")
    }
    
    @objc  func updateLanguage() {
        self.saveAction.setTitle(AppLocalizationKeys.save.localized(), for: .normal)
        self.cancelAction.setTitle(AppLocalizationKeys.cancel.localized(), for: .normal)
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }

    @IBAction func timeSelectedAction(_ sender: Any) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        if let hours = components.hour, let minutes = components.minute {
            DefaultsManager.hours = hours
            DefaultsManager.minutes = minutes
            voidBlock?()
          }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
