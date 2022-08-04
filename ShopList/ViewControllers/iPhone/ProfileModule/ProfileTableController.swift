//
//  ProfileTableController.swift
//  ShopList
//
//  Created by Illia Romanenko on 29.07.22.
//

import Foundation
import UIKit
import Firebase

class ProfileTableController: UIViewController {
    
    private let imagePicker = UIImagePickerController()
    private let menu = SLProfilePoints.getMenu()
    
    private var spinner: UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: view.center.x, y: view.center.y, width: 40, height: 40))
        indicator.hidesWhenStopped = true
        indicator.tintColor = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    var tableView: UITableView {
        let table = UITableView(frame: self.view.frame, style: .insetGrouped)
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

        title = "Профиль"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
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
        case .picture:
            present(imagePicker, animated: true, completion: nil)
        case .name:
            UIPasteboard.general.string = DefaultsManager.email
        default: break
        }
    }
}

extension ProfileTableController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        spinner.startAnimating()
        SLFirManager.uploadPhoto(image: image) { [weak self] success in
            if success {
                self?.spinner.stopAnimating()
            }
        }
        self.dismiss(animated: true)
    }
}
