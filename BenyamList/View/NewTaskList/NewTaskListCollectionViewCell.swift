//
//  NewTaskListCollectionViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 30.11.2022.
//

import UIKit

class NewTaskListCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet{
            if isSelected{
                select()
            }else{
                deselect()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 3.0
        view.isHidden = true
        return view;
    }()
    
    let colorView: UIView = {
        let view  = UIView()
        view.clipsToBounds = true
        return view
    }()

    static let identifier = "NewTaskListCollectionViewCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(colorView)
        addSubview(borderView)
        if isSelected{
            borderView.isHidden = false
        }
    }
    
    func configure(with color: CategoryColor, and height: CGFloat){
        colorView.backgroundColor = .getColor(from: color)
        setupView(with: height)
    }
    
    func select(){
        borderView.isHidden = false
    }

    func deselect(){
        borderView.isHidden = true
    }
    
    private func setupView(with height: CGFloat){
        let colorViewWidth = height / 4 + 5
        let colorViewHeight = colorViewWidth
        colorView.layer.cornerRadius = colorViewWidth / 2
        colorView.frame = CGRect(x: (contentView.width - colorViewWidth) / 2, y: (contentView.height - colorViewHeight) / 2, width: colorViewWidth, height: colorViewHeight)
        
        let borderViewWidth = colorViewWidth + 11
        let borderViewHeight = colorViewHeight + 11
        borderView.layer.cornerRadius = borderViewWidth / 2
        borderView.frame = CGRect(x: (contentView.width - borderViewWidth) / 2, y: (contentView.height - borderViewHeight) / 2, width: borderViewWidth, height: borderViewHeight)
    }

}
