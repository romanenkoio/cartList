//
//  PopupView.swift
//  ShopList
//
//  Created by Illia Romanenko on 7.08.22.
//

import Foundation
import UIKit

class PopupView: UIView {
    
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var titleLabel: UILabel?
    private var stackView = UIStackView()
    
    private var isShowen = false
    private var title: String?

    
    
    // Value less than 0 requires manual dismissing
    var presentationTime = TimeInterval(1)
    var eventOnDismissed: ((PopupView) -> ())?

    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(title: String, presentationTime: TimeInterval = 1) {
        self.init()
        self.presentationTime = presentationTime
        self.title = title

        configureViews()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        configureViews()
    }
    
    
    private func configureViews() {
        addSubview(backgroundView)
        
        stackView.axis = .vertical
        stackView.spacing = 0
        backgroundView.backgroundColor = .mainOrange.withAlphaComponent(0.2)
        backgroundView.layer.borderColor = UIColor.mainOrange.withAlphaComponent(0.4).cgColor
        backgroundView.layer.borderWidth = 0.25
        backgroundView.contentView.backgroundColor = .clear
        backgroundView.contentView.addSubview(stackView)
        
        stackView.distribution = .fillProportionally
        stackView.contentMode = .center
        
        if title != nil {
            titleLabel = UILabel()
            titleLabel?.text = title
            titleLabel?.textColor = UIColor.darkGray
            titleLabel?.textAlignment = .center
            titleLabel?.numberOfLines = 0
            stackView.addArrangedSubview(titleLabel!)
        }
       
        pinViews()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let superview = superview {
            frame = superview.bounds
        }
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
    }
    
    private func pinViews() {
        backgroundView.constraints.forEach { backgroundView.removeConstraint($0) }
        titleLabel?.constraints.forEach { titleLabel?.removeConstraint($0) }
        stackView.constraints.forEach { stackView.removeConstraint($0) }
        
        var width = CGFloat(150)
        var height = CGFloat(0)
        if titleLabel != nil  {
            titleLabel?.sizeToFit()
            
            width += 50
            height += (titleLabel?.bounds.height ?? 0)
        }
        
        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100).isActive = true
        backgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: width).isActive = true
        backgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width - 30).isActive = true
        backgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 15).isActive = true
        stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15).isActive = true
        stackView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -15).isActive = true
        stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -15).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel?.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        titleLabel?.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        layoutIfNeeded()
    }
    
    
    // MARK: - Presentation
    
    func show(_ animated: Bool = true) {
        guard let window = UIApplication.shared.keyWindow else {
            print("Can't show PopupView. Key window of application is nil")
            return
        }
        guard isShowen == false else {
            print("Show will be ignored. The PopupView already presented")
            return
        }
        
        if animated {
            backgroundView.alpha = 0
            backgroundView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            UIView.setAnimationCurve(.easeOut)
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.alpha = 1
                self.backgroundView.transform = .identity
            })
        } else {
            backgroundView.alpha = 1
            backgroundView.transform = .identity
        }
        
        window.addSubview(self)
        startDismissTimer()
        isShowen = true
    }
    
    func dismiss(_ animated: Bool = true) {
        isShowen = false
        backgroundView.alpha = 1
        backgroundView.transform = .identity
        if animated {
            UIView.setAnimationCurve(.easeOut)
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.alpha = 0
                self.backgroundView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }) { completed in
                guard completed == true else  { return }
                self.removeFromSuperview()
                self.eventOnDismissed?(self)
            }
        } else {
            removeFromSuperview()
            eventOnDismissed?(self)
        }
    }
    
    private func startDismissTimer() {
        guard presentationTime > 0 else {
            print("PopupView requires manual dismissing")
            return
        }
        
        let timer = Timer(timeInterval: presentationTime, repeats: false) { timer in
            timer.invalidate()
            self.dismiss()
        }
        
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
    }
}
