//
//  NewTaskCategoryCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 04.01.2023.
//

import UIKit

protocol NewTaskCategoryCellDelegate: AnyObject{
    func didSelectCategory(with category: Category)
}

class NewTaskCategoryCell: UITableViewCell {

    static let identifier = "NewTaskCategoryCell"
    
    var allCategories = Database.shared.allCategories
    var selectedCategory: Int?
    
    private let spacing: CGFloat = 5
    
    weak var delegate: NewTaskCategoryCellDelegate?
    
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
    
    func configure(with task: Task){
        for i in allCategories.indices{
            if task.category.name == allCategories[i].name{
                selectedCategory = i
            }
        }
    }
    
}

extension NewTaskCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTaskCategoryCollectionViewCell.identifier, for: indexPath) as!
        NewTaskCategoryCollectionViewCell
        if let index = selectedCategory, index == indexPath.row{
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        cell.configure(with: allCategories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let len = allCategories[indexPath.row].name.count
        return CGSize(width: CGFloat(len * 15), height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NewTaskCategoryCollectionViewCell
        let category = cell.category ?? Category(name: "All", color: .magenta)
        delegate?.didSelectCategory(with: category)
    }
}
