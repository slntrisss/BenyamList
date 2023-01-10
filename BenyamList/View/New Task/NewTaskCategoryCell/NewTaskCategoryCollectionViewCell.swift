//
//  NewTaskCategoryCollectionViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 04.01.2023.
//

import UIKit

class NewTaskCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewTaskCategoryCollectionViewCell"
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                borderView.isHidden = false
            }else{
                borderView.isHidden = true
            }
        }
    }
    
    private let categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [borderView, categoryView].forEach(addSubview(_:))
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: Category){
        categoryLabel.text = category.name
        self.categoryView.backgroundColor = UIColor.getColor(from: category.color)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderView.layer.cornerRadius = categoryView.height * 0.2
        borderView.layer.masksToBounds = true
        
        categoryView.layer.cornerRadius = categoryView.height * 0.2
        categoryView.layer.masksToBounds = true
    }
    
    private func setConstraints(){
        
        categoryView.anchor(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                            padding: .init(top: 10, left: 3, bottom: 10, right: 3))
        
        borderView.anchor(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor,
                          padding: .init(top: 7, left: .zero, bottom: 7, right: .zero))
        
        categoryView.addSubview(categoryLabel)

        categoryLabel.anchor(leading: categoryView.leadingAnchor, top: categoryView.topAnchor, trailing: categoryView.trailingAnchor, bottom: categoryView.bottomAnchor)
    }
}
