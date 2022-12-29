//
//  CategoryCollectionViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 07.12.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryCollectionViewCell"
    
    override var isSelected: Bool{
        didSet{
            checkSelected()
        }
    }
    
    lazy private var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(categoryLabel)
        
        
        categoryLabel.anchor(leading: self.leadingAnchor, top: self.topAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
        
        self.layer.cornerRadius = self.layer.bounds.height * 0.5
        self.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with category: Category){
        checkSelected()
        categoryLabel.text = category.name    }
    
    private func checkSelected(){
        if isSelected {
            backgroundColor = .hexStringToUIColor(hex: "#FFA400")
            categoryLabel.textColor = .black
        }else{
            backgroundColor = .systemGray5
            categoryLabel.textColor = .darkGray
        }
    }
    
}
