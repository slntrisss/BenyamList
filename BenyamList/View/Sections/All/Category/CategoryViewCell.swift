//
//  CategoryViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 07.12.2022.
//

import UIKit

protocol CategoryViewCellDelegate: AnyObject{
    func categorySelected(category: Category)
}

class CategoryViewCell: UITableViewCell {
    
    static let identifier = "CategoryViewCell"
    
    var categories = [Category]()
    
    weak var delegate: CategoryViewCellDelegate?
    
    lazy private var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(categoryCollectionView)
        
        categoryCollectionView.anchor(leading: self.contentView.leadingAnchor, top: self.contentView.topAnchor, trailing: self.contentView.trailingAnchor, bottom: self.contentView.bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
extension CategoryViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let len = categories[indexPath.row].name.count
        return CGSize(width: CGFloat(len * 15), height: categoryCollectionView.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = delegate{
            delegate.categorySelected(category: categories[indexPath.row])
        }
    }
    
}
