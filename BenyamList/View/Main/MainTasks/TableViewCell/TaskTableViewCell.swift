//
//  TaskTableViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var numberOfTasks: UILabel!
    
    static let identifier = "TaskTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with taskList: TaskList){
        taskLabel.text = taskList.category.name
        iconView.layer.cornerRadius = iconView.layer.bounds.height / 2.7
        numberOfTasks.text = String(taskList.tasks.count)
        iconView.clipsToBounds = true
        iconView.backgroundColor = .getColor(from: taskList.category.color)
    }
    
}
