//
//  NewTaskDetailCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 26.12.2022.
//

import UIKit

protocol NewTaskDetailCellDelegate: AnyObject{
    func textFieldDidEndEditing(with text: String, and cell: DescriptionCell)
    
//    func textFieldDidEdit(with text: String)
}

class NewTaskDetailCell: UITableViewCell {

    static let identifier = "NewTaskDetailCell"
    
    private var cellType: DescriptionCell!
    
    weak var delegate: NewTaskDetailCellDelegate!
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 18, weight: .semibold)
        field.borderStyle = .none
        field.textColor = .darkGray
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.isUserInteractionEnabled = true
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(getText), for: .editingChanged)
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
    
    func configure(with cell: DescriptionCell, _ task: Task){
        self.cellType = cell
        textField.placeholder = cell == DescriptionCell.title ? "Task Name" : "Description"
        if !task.title.isEmpty && cell == DescriptionCell.title{
            textField.text = task.title
        }else if let details = task.details, cell == DescriptionCell.detail, !details.isEmpty{
            textField.text = details
        }
    }
    
    func initConstraints(){
        contentView.isUserInteractionEnabled = false
        textField.anchor(leading: leadingAnchor, top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
    }
    
    @objc private func getText(){
        if let text = textField.text{
            delegate.textFieldDidEndEditing(with: text, and: self.cellType)
            
        }
    }
    
}

extension NewTaskDetailCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

enum DescriptionCell{
    case title, detail
}
