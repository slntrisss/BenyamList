//
//  NewTaskReminderCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 27.12.2022.
//

import UIKit

protocol NewTaskReminderCellDelegate{
    func switchIsCliked(in cell: DateOrTimeCell)
}

class NewTaskReminderCell: UITableViewCell {

    static let identifier = "NewTaskReminderCell"
    
    var delegate: NewTaskReminderCellDelegate?
    
    var cellType: DateOrTimeCell?
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let reminderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    lazy var isEnabled: UISwitch = {
        let isEnabled = UISwitch()
        isEnabled.isEnabled = true
        isEnabled.translatesAutoresizingMaskIntoConstraints = false
        isEnabled.addTarget(self,
                            action: #selector(didTapSwitch),
                            for: .valueChanged)
        return isEnabled
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        [icon, reminderLabel, isEnabled].forEach(addSubview(_:))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //icon
        icon.anchor(leading: leadingAnchor, top: nil, trailing: nil, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        icon.centerAnchor(centerX: nil, centerY: centerYAnchor, xPadding: 0, yPadding: 0)
        icon.sizeAnchor(width: 30, height: 30)

        //reminder
        reminderLabel.anchor(leading: icon.trailingAnchor, top: nil, trailing: nil, bottom: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        reminderLabel.centerAnchor(centerX: nil, centerY: centerYAnchor, xPadding: 0, yPadding: 0)

        //switch
        isEnabled.anchor(leading: nil, top: nil, trailing: trailingAnchor, bottom: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        isEnabled.centerAnchor(centerX: nil, centerY: centerYAnchor, xPadding: 0, yPadding: 0)
    }
    
    func configure(with dateAndTimeType: DateOrTimeCell){
        self.cellType = dateAndTimeType
        switch dateAndTimeType {
        case .date:
            icon.image = UIImage(systemName: "calendar")
            reminderLabel.text = "Date"
        case .time:
            icon.image = UIImage(systemName: "clock")
            reminderLabel.text = "Time"
        }
    
    }
    
    @objc func didTapSwitch(){
        if let cellType = cellType {
            self.delegate?.switchIsCliked(in: cellType)
        }
    }
    
}

enum DateOrTimeCell{
    case date, time
}
