//
//  AddListController.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit

final class AddListController: UIViewController {
    @IBOutlet private weak var productInput: UITextField!
    @IBOutlet private weak var countInput: NoActionTextField!
    @IBOutlet private weak var pkgView: UIView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var pkgButton: UIButton!
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    var saveAction: VoidBlock?
    private var seletedPkg = SLProductPackage.pieces
    var type: SLAddType = .list
    var list: SLRealmList?
    
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
        typeLabel.text = type.rawValue
        productInput.placeholder = type.placeholder
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
        switch type {
        case .list:
            guard let listName = productInput.text,
                  !listName.isEmpty
            else { return }
            RealmManager.write(object: SLRealmList(listName: listName))
        case .product:
            guard let productName = productInput.text,
                  !productName.isEmpty,
                  let list = list
            else { return }
            RealmManager.write(object: SLRealmProduct(productName: productName, produckPkg: seletedPkg.pkgAbb, productCount: Double(count), listID: list.id))
        }
        NotificationCenter.default.post(name: .listWasImported, object: nil)
        saveAction?()
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