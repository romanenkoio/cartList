//
//  AddListController.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit
import Firebase

final class AddListController: UIViewController {
    @IBOutlet private weak var productInput: UITextField!
    @IBOutlet private weak var countInput: NoActionTextField!
    @IBOutlet private weak var pkgView: UIView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet private weak var pkgButton: UIButton!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    var saveAction: VoidBlock?
    private var seletedPkg = SLProductPackage.pieces
    var type: SLAddType = .list
    var list: SLRealmList?
    var currentList: SLFirebaseList?
    
    private var count: Float = 1.0 {
        didSet {
            countInput.text = "\(count)"
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.borderColor = UIColor.mainOrange.cgColor
        countInput.text = "\(count)"
        countInput.delegate = self
        pkgView.isHidden = type == .list
        typeLabel.text = type.localizedValue.localized()
        productInput.placeholder = type.placeholder.localized()
        mainView.layer.borderColor = UIColor.mainOrange.withAlphaComponent(0.8).cgColor
        
        pkgButton.menu = UIMenu(children: [
            CustomUIAction(title: SLProductPackage.pieces.pkg, state: .on, handler: { _ in
                self.seletedPkg = .pieces
            }),
            CustomUIAction(title: SLProductPackage.litres.pkg, state: .on, handler: { _ in
                self.seletedPkg = .litres
            }),
            CustomUIAction(title: SLProductPackage.kilograms.pkg, state: .on, handler: { _ in
                self.seletedPkg = .kilograms
            }),
            CustomUIAction(title: SLProductPackage.package.pkg, state: .on, handler: { _ in
                self.seletedPkg = .package
            }),
            CustomUIAction(title: SLProductPackage.jar.pkg, state: .on, handler: { _ in
                self.seletedPkg = .jar
            })])
        
        pkgButton.showsMenuAsPrimaryAction = true
        pkgButton.changesSelectionAsPrimaryAction = true
        updateLanguage()
        subscribeToNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }

    @objc func keyboardWillAppear(notification: NSNotification) {
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        self.bottomConstraint.constant = keyboardHeight + 10
        self.bottomConstraint.isActive = true
        self.verticalConstraint.isActive = false
        UIView.animate(withDuration: 1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        count += seletedPkg.pkgStep
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        count -= seletedPkg.pkgStep
        if count < 0.5 {
            count = seletedPkg.pkgStep
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        switch type {
        case .list:
            guard let listName = productInput.text,
                  !listName.isEmpty
            else { return }
            let listsRef = Database.database().reference().child("users/\(uid)/lists").childByAutoId()
            listsRef.setValue(["listName" : listName, "isPinned" : false])
//            saveAction?()
            
        case .product:
            guard let productName = productInput.text,
                  !productName.isEmpty
            else { return }
            
            guard let id = currentList?.id else { return }
            let listsRef = Database.database().reference().child("users/\(uid)/lists/\(id)/products").childByAutoId()
            listsRef.setValue(["productName" : productName, "produckPkg" : seletedPkg.pkgAbb, "productCount" : Double(count), "checked" : false])
            saveAction?()
        }
        NotificationCenter.default.post(name: .listWasImported, object: nil)
        saveAction?()
    }
    
    @objc  func updateLanguage() {
        self.backButton.setTitle(AppLocalizationKeys.cancel.localized(), for: .normal)
        self.saveButton.setTitle(AppLocalizationKeys.save.localized(), for: .normal)
        self.unitLabel.text = AppLocalizationKeys.unit.localized()
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguage), name: .languageChange, object: nil)
    }
}

extension AddListController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countInput {
            return false;
        }
        return true
    }
}
