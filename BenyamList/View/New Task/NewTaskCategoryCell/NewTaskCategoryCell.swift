//
//  NewTaskCategoryCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 04.01.2023.
//

import UIKit

class NewTaskCategoryCell: UITableViewCell {

    static let identifier = "NewTaskCategoryCell"
    
    var allCategories = Database.shared.allCategories
    
    private let spacing: CGFloat = 5
    
    //Views
    lazy private var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(NewTaskCategoryCollectionViewCell.self, forCellWithReuseIdentifier: NewTaskCategoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(categoryCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryCollectionView.frame = contentView.bounds
    }
    
}

extension NewTaskCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTaskCategoryCollectionViewCell.identifier, for: indexPath) as!
        NewTaskCategoryCollectionViewCell
        cell.configure(with: allCategories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let len = allCategories[indexPath.row].name.count
        return CGSize(width: CGFloat(len * 15), height: 60)
    }
}
