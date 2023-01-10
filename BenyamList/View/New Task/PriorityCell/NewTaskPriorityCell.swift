//
//  NewTaskPriorityCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 05.01.2023.
//

import UIKit

protocol NewTaskPriorityCellDelegate:AnyObject{
    func prioritySwitchClicked()
}

class NewTaskPriorityCell: UITableViewCell {

    static let identifier = "NewTaskPriorityCell"
    
    weak var delegate: NewTaskPriorityCellDelegate!
    
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .darkGray
        label.text = "Priority"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var prioritySwicth: UISwitch = {
        let prioritySwitch = UISwitch()
        prioritySwitch.translatesAutoresizingMaskIntoConstraints = false
        prioritySwitch.addTarget(self, action: #selector(didTapPrioritySwitch), for: .valueChanged)
        return prioritySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        [priorityLabel, prioritySwicth].forEach(addSubview(_:))
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapPrioritySwitch(){
        delegate.prioritySwitchClicked()
    }
    
    private func setConstraints(){
        
        priorityLabel.anchor(leading: leadingAnchor, top: nil, trailing: nil, bottom: nil,
                             padding: .init(top: .zero, left: 10, bottom: .zero, right: .zero))
        priorityLabel.centerAnchor(centerX: nil, centerY: centerYAnchor, xPadding: .zero, yPadding: .zero)
        
        prioritySwicth.anchor(leading: nil, top: nil, trailing: trailingAnchor, bottom: nil,
                              padding: .init(top: .zero, left: .zero, bottom: .zero, right: 20))
        prioritySwicth.centerAnchor(centerX: nil, centerY: centerYAnchor, xPadding: .zero, yPadding: .zero)
    }
    
    func configure(isShowing: Bool){
        prioritySwicth.setOn(isShowing, animated: false)
    }
    
}
