//
//  SettingsController.swift
//  ShopList
//
//  Created by Illia Romanenko on 22.04.22.
//

import UIKit
import Firebase
import MessageUI

class SettingsController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var points = SLSettingsPoint.getMenu()
    private var timePicker = UIDatePicker()
    private let languages = Languages.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellsWith([SettingCell.self, SettingsHeaderCell.self, ProfileCell.self])
        tableView.sectionFooterHeight = 20
        setupDatePicker()
        updateLanguage()
        subscribeToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupDatePicker() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc  func updateLanguage() {
        self.title = AppLocalizationKeys.settings.localized()
        tableView.reloadData()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["zamok.tech@gmail.com"])
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let version = "\(AppLocalizationKeys.version.localized()): \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? AppLocalizationKeys.versionInfo.localized())"
            let mailString = "UserID: \(uid)\n \(version)\n\(AppLocalizationKeys.mailText.localized())"
            mail.setMessageBody(mailString, isHTML: false)
            
            present(mail, animated: true)
        } else {
            PopupView(title: AppLocalizationKeys.mailSettings).show()
        }
    }
}

extension SettingsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return points.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return points[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var settingCell: UITableViewCell
  
        let point = points[indexPath.section][indexPath.row]
        switch point {
        case .profile:
            settingCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.id, for: indexPath)
        case .autoDelete, .useTimePush, .morningTime, .version, .separateList, .language, .premium, .feedback, .biometry:
            settingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingCell.self), for: indexPath) as! SettingCell
            
            (settingCell as! SettingCell).setupWith(point)
            
            (settingCell as! SettingCell).switchAction = { [weak self] isOn in
                guard let self = self else { return }
                
                switch point {
                case .autoDelete:
                    DefaultsManager.autoDelete = !DefaultsManager.autoDelete
                case .useTimePush:
                    DefaultsManager.timeNotification = !DefaultsManager.timeNotification
                    NotificationManager.scheduleTimeNotifications()
                case .separateList:
                    DefaultsManager.separateProducts = !DefaultsManager.separateProducts
                case .biometry:
                    DefaultsManager.useBiometry = !DefaultsManager.useBiometry

                default: break
                    
                }
                self.tableView.reloadData()
            }
        }

        return settingCell
    }
}

extension SettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.points[indexPath.section][indexPath.row] {
            
        case .morningTime:
            guard DefaultsManager.timeNotification else { return }
            let timeVC = TimeSelectPopupController.loadFromNib()
            timeVC.modalPresentationStyle = .overCurrentContext
            timeVC.modalTransitionStyle = .crossDissolve
            
            timeVC.voidBlock = { [weak self] in
                self?.tableView.reloadData()
                NotificationManager.scheduleTimeNotifications()
                self?.dismiss(animated: true)
            }
            self.present(timeVC, animated: true)
        case .language:
            let alert = UIAlertController(title: "", message: AppLocalizationKeys.chooseLanguage.localized(), preferredStyle: .actionSheet)
            
            for lang in languages {
                let action = UIAlertAction(title: lang.rawValue, style: .default) { _ in
                    print("\(AppLocalizationKeys.setLanguage.localized()): \(lang.rawValue)")
                    Bundle.setLanguage(lang: lang.short)
                }
                alert.addAction(action)
            }
            alert.addAction(UIAlertAction(title: AppLocalizationKeys.back.localized(), style: .cancel))
            self.present(alert, animated: true)
        case .profile:
            if Auth.auth().currentUser?.uid != nil {
                let profileVC = ProfileTableController()
                navigationController?.pushViewController(profileVC, animated: true)
            }
        case .premium:
            let vc = PremiumController.loadFromNib()
            present(vc, animated: true)
        case .feedback:
            sendEmail()
        default: break
        }
    }
}

extension SettingsController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
