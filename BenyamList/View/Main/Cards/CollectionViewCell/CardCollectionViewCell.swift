//
//  CardCollectionViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var numberOfTasks: UILabel!
    @IBOutlet weak var title: UILabel!
    
    static let identifier = "CardCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with card: Card){
        icon.image = UIImage(systemName: card.icon)
        numberOfTasks.text = String(card.totalNumberOfTasks)
        title.text = card.type.rawValue
        configureIcon(card)
    }
    
    private func configureIcon(_ card: Card){
        cardView.layer.cornerRadius = CGFloat(7)
        iconView.layer.cornerRadius = iconView.layer.bounds.width / 4
        iconView.clipsToBounds = true
        iconView.backgroundColor = UIColor.hexStringToUIColor(hex: card.iconBackgroundColor)
    }

}
