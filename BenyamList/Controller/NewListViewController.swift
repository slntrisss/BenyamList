//
//  NewListViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 30.11.2022.
//

import UIKit

class NewListViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let newListView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    private let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.getColor(from: .dodgerBlue)
        return view
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.dash")
        imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.textAlignment = .center
        field.placeholder = "Task List Name"
        field.layer.cornerRadius = 12
        field.backgroundColor = .systemGray5
        field.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        field.textColor = .getColor(from: .dodgerBlue)
        return field
    }()

    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 12
        collectionView.clipsToBounds = true
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "New Task List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancelButton))
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(newListView)
        newListView.addSubview(iconView)
        iconView.addSubview(icon)
        newListView.addSubview(textField)
        scrollView.addSubview(colorCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        setupNewListView()
        setupIconView()
        setupIcon()
        setupTextField()
        setupCollectionView()
    }
    
    @objc private func didTapSaveButton(){}

    @objc private func didTapCancelButton(){
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        guard let text = textField.text else{return}
        
        if text.isEmpty || text.count < 2 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    private func setupNewListView(){
        let height = scrollView.height / 4
        let width = scrollView.width - 40
        newListView.frame = CGRect(x: 20, y: 10, width: width, height: height)
    }
    
    private func setupIconView(){
        let height = newListView.height / 2
        let width = height
        iconView.frame = CGRect(x: (newListView.width - width) / 2, y: 20, width: width, height: height)
        iconView.layer.cornerRadius = iconView.layer.bounds.width / 2
        iconView.clipsToBounds = true
    }
    
    private func setupIcon(){
        let width = iconView.width / 2
        let height = width
        icon.frame = CGRect(x: (iconView.width - width) / 2, y: (iconView.height - height) / 2, width: width, height: height)
    }
    
    private func setupTextField(){
        let width = newListView.width - 60
        let height:CGFloat = 52
        let y: CGFloat = iconView.height + 40
        textField.frame = CGRect(x: (newListView.width - width) / 2, y: y, width: width, height: height)
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupCollectionView(){
        let colorCount = CategoryColor.allCases.count
        let numberOfRows = Int(ceil(Double(colorCount) / 6))
        let width = scrollView.width - 40
        let height = newListView.height * 0.25;
        let y = newListView.height + 40
        colorCollectionView.frame = CGRect(x: (scrollView.width - width) / 2, y: y, width: width, height: height * CGFloat(numberOfRows))
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(NewTaskListCollectionViewCell.self, forCellWithReuseIdentifier: NewTaskListCollectionViewCell.identifier)
    }
}

extension NewListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTaskListCollectionViewCell.identifier, for: indexPath) as! NewTaskListCollectionViewCell
        let color = CategoryColor.allCases[indexPath.row]
        if color == .dodgerBlue{
            cell.isSelected = true
        }
        cell.configure(with: color, and: newListView.width * 0.25)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewTaskListCollectionViewCell.identifier, for: indexPath) as! NewTaskListCollectionViewCell
        let color = UIColor.getColor(from: CategoryColor.allCases[indexPath.row])
        cell.colorView.backgroundColor = color
        self.textField.textColor = color
        cell.isSelected = true
        iconView.backgroundColor = color
    }
    
}

extension NewListViewController: UITextFieldDelegate{
    
}
