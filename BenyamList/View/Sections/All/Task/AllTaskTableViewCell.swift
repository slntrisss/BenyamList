//
//  AllTaskTableViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 07.12.2022.
//

import UIKit

class AllTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var categoryLabel: UILabelPadding!
    @IBOutlet weak var mainView: UIView!
    
    static let identifier = "AllTaskTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with task: Task){
        title.text = task.title
        if let taskDescription = task.details{
            detail.text = taskDescription
        }
        timeLabel.text = getTime(from: task.deadline)
        
        setCategory(category: task.category)
        setStatus(status: task.status)
        setPriority(priority: task.priority)
    }
    
    private func setCategory(category: Category){
        categoryLabel.clipsToBounds = true
        categoryLabel.text = category.name
        categoryLabel.backgroundColor = .getColor(from: category.color)
        categoryLabel.layer.cornerRadius = categoryLabel.layer.bounds.width / 8
    }
    
    private func setStatus(status: Status?){
        guard let status = status else {
            return
        }
        let statusLabel = UILabelPadding()
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.boldSystemFont(ofSize: 10)
        statusLabel.layer.masksToBounds = true
        statusLabel.textColor = .white
        statusLabel.text = status.rawValue
        statusLabel.backgroundColor = .getStatusColor(from: status)
        statusLabel.layer.cornerRadius = 4
        categoryStackView.addArrangedSubview(statusLabel)
    }
    
    private func setPriority(priority: Priority?){
        guard let priority = priority else {
            return
        }
        let priorityLabel = UILabelPadding()
        priorityLabel.textAlignment = .center
        priorityLabel.textColor = .white
        priorityLabel.font = UIFont.boldSystemFont(ofSize: 10)
        priorityLabel.layer.masksToBounds = true
        priorityLabel.text = priority.rawValue
        priorityLabel.backgroundColor = .getPriorityColor(from: priority)
        priorityLabel.layer.cornerRadius = 4
        categoryStackView.addArrangedSubview(priorityLabel)
    }
    
    private func getTime(from date: Date?) -> String{
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: date)
        }
        return ""
    }
    
}