//
//  NewTaskPriorityPickerCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 05.01.2023.
//

import UIKit

class NewTaskPriorityPickerCell: UITableViewCell {

    static let identifier = "NewTaskPriorityPickerCell"
    
    private let priorities: [String] = {
        var priorities = [String]()
        for priority in Priority.allCases{
            priorities.append(priority.rawValue)
        }
        return priorities
    }()
    
    lazy private var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pickerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pickerView.anchor(leading: contentView.leadingAnchor, top: contentView.topAnchor,
                          trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor)
    }
    
}

extension NewTaskPriorityPickerCell: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorities.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(priorities[row])
    }
    
}
