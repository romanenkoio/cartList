//
//  MainListCell.swift
//  ShopList
//
//  Created by Illia Romanenko on 23.04.22.
//

import UIKit

class MainListCell: UITableViewCell {
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var peopleStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setupWith(_ list: SLFirebaseList) {
     
        pinImage.isHidden = !DefaultsManager.pinnedLists.contains(list.id!)
        
        cellView.backgroundColor = DefaultsManager.pinnedLists.contains(list.id!) ? .mainOrange.withAlphaComponent(0.3) : .appBackgroundColor
        
        listNameLabel.text = list.listName
        cellView.layer.borderColor = UIColor.mainOrange.cgColor
        itemNumberLabel.text = "\(list.products.filter({ $0.checked }).count)/\(list.products.count)"
        if list.products.count != 0 {
            if list.products.filter({ $0.checked }).count == list.products.count {
                listNameLabel.strikeThrough()
            } else {
                listNameLabel.strikeThrough(false)
            }
        }
        
        SLFirManager.loadSharedUsersFor(list: list) { [weak self] users in
            self?.peopleStack.subviews.forEach({ $0.removeFromSuperview() })
            list.sharedFor = users
          
            var counter = 0
            
            for user in users.sorted(by: { $0.name ?? "" < $1.name ?? "" }) {
                if counter == 3 {
                    break
                }
                
                let imageView = UIImageView()
                imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 15
                
                if users.count >= 3, counter == 0 {
                    imageView.backgroundColor = .lightGray
                    self?.peopleStack.addArrangedSubview(imageView)
                    self?.peopleStack.sendSubviewToBack(imageView)
                    let label = UILabel(frame: CGRect(x: imageView.center.x, y: imageView.center.y, width: 30, height: 30))
                    label.text = "\(users.count)"
                    label.textColor = .white
                    label.textAlignment = .center
                    imageView.addSubview(label)
                    counter += 1
                    continue
                }
               
                imageView.setImage(url: user.photoUrl)
                
                self?.peopleStack.addArrangedSubview(imageView)
                self?.peopleStack.sendSubviewToBack(imageView)

                counter += 1
            }
    
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        listNameLabel.strikeThrough(false)
        peopleStack.subviews.forEach({ $0.removeFromSuperview() })
    }
}
