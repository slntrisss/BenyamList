//
//  NewTaskDateCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 27.12.2022.
//

import UIKit

class NewTaskDateAndTimeCell: UITableViewCell {

    static let identifier = "NewTaskDateCell"
    
    lazy private var datePicker: UIDatePicker = {
        let width = 60
        let height = 30
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    lazy private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        addSubview(dateLabel)
        addSubview(datePicker)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.anchor(leading: leadingAnchor, top: nil, trailing: nil, bottom: nil, padding: .init(top: .zero, left: 20, bottom: .zero, right: .zero))

        datePicker.anchor(leading: nil, top: nil, trailing: trailingAnchor, bottom: nil, padding: .init(top: .zero, left: .zero, bottom: .zero, right: 20))
        
    }
    
    func setCenterConstraints(show: Bool){
        datePicker.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = show
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = show
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with labelString: String, datePickerMode: UIDatePicker.Mode){
        dateLabel.text = labelString
        datePicker.datePickerMode = datePickerMode
    }
    
}
