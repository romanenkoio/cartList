//
//  ProfileTableController.swift
//  ShopList
//
//  Created by Illia Romanenko on 29.07.22.
//

import Foundation
import UIKit
import Firebase

class ProfileTableController: BaseViewController {
    
    private let imagePicker = UIImagePickerController()
    private var menu = SLProfilePoints.getMenu(edit: false)
    private var isEdit = false
    private var oldProfileImage: UIImage?
    private var newUsername: String?
    
    private var spinner: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 40, height: 40))
        indicator.hidesWhenStopped = true
        indicator.tintColor = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    var tableView: UITableView {
        let table = UITableView(frame: self.view.frame, style: .insetGrouped)
        table.bounces = false
        table.dataSource = self
        table.delegate = self
        table.registerCellsWith([SettingCell.self, ProfileCell.self])
        table.backgroundColor = .clear
        return table
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        self.view.bringSubviewToFront(spinner)

        title = AppLocalizationKeys.profileHeader.localized()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
    }
    
    @objc private func showPhotoGalleryAction(sender: UITapGestureRecognizer) {
        let alert = Alerts.changeAvatar.controller
        let selectAction = UIAlertAction(title: "Выбрать фото из галереи", style: .default, handler: { _ in
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: "Удилить фото", style: .destructive) { _ in
            let alert = Alerts.deleteAvatar.controller
            let deleteAction = UIAlertAction(title: "Да", style: .destructive) { _ in
                SLFirManager.removePhoto()
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(selectAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ProfileTableController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var settingCell = UITableViewCell()
        
        switch menu[indexPath.section][indexPath.row] {
        case .picture:
            settingCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.id, for: indexPath) as! ProfileCell
            (settingCell as! ProfileCell).indicator.isHidden = true
            (settingCell as! ProfileCell).isEdit = isEdit
            (settingCell as! ProfileCell).setupEditingStatus()
            let tap = UITapGestureRecognizer(target: self, action: #selector(showPhotoGalleryAction(sender:)))
            (settingCell as! ProfileCell).cameraImage.addGestureRecognizer(tap)
            oldProfileImage = (settingCell as! ProfileCell).avatarImage.image
            (settingCell as! ProfileCell).postNewUsername = {
                self.newUsername = (settingCell as! ProfileCell).usernameField.text
            }

        default:
            settingCell = tableView.dequeueReusableCell(withIdentifier: SettingCell.id, for: indexPath)
            (settingCell as! SettingCell).setupWith(menu[indexPath.section][indexPath.row])
        }
       
        return settingCell
    }
}

extension ProfileTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch menu[indexPath.section][indexPath.row] {
        case .logout:
            try? Auth.auth().signOut()
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.setLoginScreen()
            }
        case .name:
            UIPasteboard.general.string = DefaultsManager.email
            PopupView(title: "Скопированно").show()
        case .edit:
            menu = SLProfilePoints.getMenu(edit: true)
            tableView.reloadData()
            isEdit.toggle()
        case .saveChanges:
            menu = SLProfilePoints.getMenu(edit: false)
            tableView.reloadData()
            isEdit.toggle()
            guard let text = newUsername else { return }
            SLFirManager.updateUsername(newName: text)
        case .cancelChanges:
            menu = SLProfilePoints.getMenu(edit: false)
            self.isEdit.toggle()
            tableView.reloadData()
            guard let image = oldProfileImage else { return }
            SLFirManager.uploadPhoto(image: image) { success in
                if success { }
            }
            newUsername = nil
            oldProfileImage = nil
        default: break
        }
    }
}

extension ProfileTableController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage else { return }
        
        spinner.startAnimating()
        SLFirManager.uploadPhoto(image: image) { [weak self] success in
            if success {
                self?.spinner.stopAnimating()
            }
        }
        
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true)
    }
}
