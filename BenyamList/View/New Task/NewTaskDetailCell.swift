//
//  NewTaskDetailCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 26.12.2022.
//

import UIKit

class NewTaskDetailCell: UITableViewCell {

    static let identifier = "NewTaskDetailCell"
    
    private var placeholder = ""
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .semibold)
        field.borderStyle = .none
        field.textColor = .darkGray
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.isUserInteractionEnabled = true
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with placeholder: String){
        textField.placeholder = placeholder
    }
    
    func initConstraints(){
        contentView.isUserInteractionEnabled = false
        
        textField.anchor(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
    }
    
}
