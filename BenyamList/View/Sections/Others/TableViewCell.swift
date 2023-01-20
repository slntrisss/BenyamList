//
//  TableViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 19.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var categoryLabel: UILabelPadding!
    @IBOutlet weak var priorityLabel: UILabelPadding!
    @IBOutlet weak var statusLabel: UILabelPadding!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let identifier = "TableViewCell"
    var task: Task!
    var showCategoryLabel = true
    var showPriorityLabel = true
    var showStatusLabel = true
    var type: CollectionStyle?
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.isHidden = true
        categoryLabel.isHidden = true
        priorityLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with task: Task, type: CollectionStyle){
        self.task = task
        self.type = type
        if task.status == .completed{
            restyleTextLabels()
            showLabels(task: task)
            return
        }
        title.text = task.title
        if let taskDescription = task.details{
            detail.text = taskDescription
        }else{
            detail.text = ""
        }
        timeLabel.text = getTime(from: task.deadline)
        
        showLabels(task: task)
    }
    
    private func restyleTextLabels(){
        let restyledTitleText = NSAttributedString(string: task.title).withStrikeThrough()
        let restyledTimeLabel = NSAttributedString(string: getTime(from: task.deadline)).withStrikeThrough()
        if let taskDescription = task.details{
            let restyledDetailLabel = NSAttributedString(string: taskDescription).withStrikeThrough()
            detail.attributedText = restyledDetailLabel
        }else{
            detail.text = ""
        }
        title.attributedText = restyledTitleText
        timeLabel.attributedText = restyledTimeLabel
    }
    
    private func showLabels(task: Task){
        if showStatusLabel{
            statusLabel.isHidden = false
            setStatus(status: task.status)
        }
        if showCategoryLabel{
            categoryLabel.isHidden = false
            setCategory(category: task.category)
        }
        if showPriorityLabel{
            priorityLabel.isHidden = false
            setPriority(priority: task.priority)
        }
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
        statusLabel.layer.masksToBounds = true
        statusLabel.text = status.rawValue
        statusLabel.backgroundColor = .getStatusColor(from: status)
        statusLabel.layer.cornerRadius = 4
    }
    
    private func setPriority(priority: Priority?){
        guard let priority = priority, priority != .defualt else {
            priorityLabel.isHidden = true
            return
        }
        priorityLabel.layer.masksToBounds = true
        priorityLabel.text = priority.rawValue
        priorityLabel.backgroundColor = .getPriorityColor(from: priority)
        priorityLabel.layer.cornerRadius = 4
    }
    
    private func getTime(from date: Date?) -> String{
        if let date = date, let type = type {
            if type == .Today{
                return "\(date.formatted(date: .omitted, time: .shortened))"
            }
            return "\(date.formatted(date: .abbreviated, time: .omitted))\n\(date.formatted(date: .omitted, time: .shortened))"
        }
        return ""
    }
    
}
