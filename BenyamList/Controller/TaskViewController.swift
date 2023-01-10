//
//  TaskTableViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 26.12.2022.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var headerViewTitles = ["Detail", "Date", "Time", "Category", "Priority"]
    private var dateReminder = false
    private var timeReminder = false
    private var isPriorityEnabled = false
    
    var task: Task!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(dismissViewController))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(doneButtonPressed))
        
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewTaskDetailCell.self, forCellReuseIdentifier: NewTaskDetailCell.identifier)
        tableView.register(NewTaskDateAndTimeCell.self, forCellReuseIdentifier: NewTaskDateAndTimeCell.identifier)
        tableView.register(NewTaskReminderCell.self, forCellReuseIdentifier: NewTaskReminderCell.identifier)
        tableView.register(NewTaskCategoryCell.self, forCellReuseIdentifier: NewTaskCategoryCell.identifier)
        tableView.register(NewTaskPriorityCell.self, forCellReuseIdentifier: NewTaskPriorityCell.identifier)
        tableView.register(NewTaskPriorityPickerCell.self, forCellReuseIdentifier: NewTaskPriorityPickerCell.identifier)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func dismissViewController(){
        dismiss(animated: true)
    }
    
    @objc func doneButtonPressed(){
        
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2 || section == 4{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskDetailCell.identifier, for: indexPath) as! NewTaskDetailCell
            indexPath.row == 0 ? cell.configure(with: DescriptionCell.title, task) : cell.configure(with: DescriptionCell.detail, task)
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 1{
            if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskDateAndTimeCell.identifier, for: indexPath) as! NewTaskDateAndTimeCell
                cell.configure(with: "Select a date", datePickerMode: .date)
                cell.setCenterConstraints(show: dateReminder)
                cell.delegate = self
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskReminderCell.identifier, for: indexPath) as! NewTaskReminderCell
            cell.configure(with: .date)
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 2{
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskDateAndTimeCell.identifier, for: indexPath) as! NewTaskDateAndTimeCell
                cell.configure(with: "Select a time", datePickerMode: .time)
                cell.setCenterConstraints(show: timeReminder)
                cell.delegate = self
                return cell
            }
            else if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskReminderCell.identifier, for: indexPath) as! NewTaskReminderCell
                cell.configure(with: .time)
                cell.delegate = self
                return cell
            }
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskCategoryCell.identifier, for: indexPath) as! NewTaskCategoryCell
            return cell
        }else if indexPath.section == 4{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskPriorityCell.identifier, for: indexPath) as! NewTaskPriorityCell
                cell.delegate = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskPriorityPickerCell.identifier, for: indexPath) as! NewTaskPriorityPickerCell
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let cell = tableView.cellForRow(at: indexPath) as! NewTaskDetailCell
            cell.textField.becomeFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case IndexPath(item: 1, section: 1):
            return dateReminder ? 60 : 0
        case IndexPath(item: 1, section: 2):
            return timeReminder ? 60 : 0
        case IndexPath(item: 0, section: 3):
            return 60 * calcNumberOfRowsForCategoryCell()
        case IndexPath(item: 1, section: 4):
            return isPriorityEnabled ? 120 : 0
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerViewTitles[section]
    }
    
    private func calcNumberOfRowsForCategoryCell() -> CGFloat{
        var width = 0
        let categories = Database.shared.allCategories
        
        for category in categories {
            width += (category.name.count * 15 + 10)
        }
        return CGFloat(ceil(Double(Double(width) / tableView.width)))
    }
}

extension TaskViewController: NewTaskReminderCellDelegate, NewTaskDateAndTimeCellDelegate{
    func dateOrTimeIsPicked(with mode: UIDatePicker.Mode, date: Date) {
        
        if mode == .date{
            task.deadline = date
        }
        if mode == .time{
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            guard let hour = components.hour,
                  let minute = components.minute,
                  let deadline = task.deadline else{
                return
            }
            guard let newDateFromTimeInterval = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: deadline) else{
                print("Error setting picked time interval")
                return
            }
            
            task.deadline = newDateFromTimeInterval
        }
        
        if let deadline = task.deadline{
            print(deadline.formatted(date: .abbreviated, time: .shortened))
        }
    }
    
    func switchIsCliked(in cell: DateOrTimeCell) {
        switch cell {
        case .date:
            dateReminder.toggle()
            if dateReminder{
                setDefaultDate()
            }else{
                deleteTheDate()
            }
            handleDateReminder()
        case .time:
            timeReminder.toggle()
            if timeReminder{
                setDefaultTime()
            }else{
                deleteTheTime()
            }
            handleTimeRemainder()
        }
    }
    
    private func setDefaultDate(){
        task.deadline = Calendar.current.startOfDay(for: Date.now)
    }
    
    private func deleteTheDate(){
        task.deadline = nil
    }
    
    private func setDefaultTime(){
        guard var pickedDate = task.deadline else{
            print("Something went wrong!")
            return
        }
        pickedDate = Calendar.current.startOfDay(for: pickedDate)
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        guard let hour = components.hour, let minute = components.minute else {
            return
        }
        var pickedDateWithTime = pickedDate
        pickedDateWithTime = Calendar.current.date(byAdding: .hour, value: hour, to: pickedDate)!
        pickedDateWithTime = Calendar.current.date(byAdding: .minute, value: minute, to: pickedDateWithTime)!
    }
    
    private func deleteTheTime(){
        if let deadline = task.deadline{
            task.deadline = Calendar.current.startOfDay(for: deadline)
        }
    }
    
    func handleDateReminder(){
        let indexPath = IndexPath(item: 1, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as! NewTaskDateAndTimeCell
        cell.setCenterConstraints(show: dateReminder)
        
        //handle time reminder
        if !dateReminder && timeReminder{
            
            //reminder cell
            timeReminder.toggle()
            let reminderIndexPath = IndexPath(item: 0, section: 2)
            let reminderCell = tableView.cellForRow(at: reminderIndexPath) as! NewTaskReminderCell
            reminderCell.isEnabled.setOn(timeReminder, animated: true)
            
            //time cell
            let timeIndexPath = IndexPath(item: 1, section: 2)
            let timeCell = tableView.cellForRow(at: timeIndexPath) as! NewTaskDateAndTimeCell
            timeCell.setCenterConstraints(show: timeReminder)
            
            
            tableView.reloadRows(at: [timeIndexPath], with: .fade)
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func handleTimeRemainder(){
        //time cell
        let indexPath = IndexPath(item: 1, section: 2)
        let cell = tableView.cellForRow(at: indexPath) as! NewTaskDateAndTimeCell
        cell.setCenterConstraints(show: timeReminder)
        
        
        //handle date reminder
        if !dateReminder && timeReminder{
            
            //reminder cell
            dateReminder.toggle()
            let reminderIndexPath = IndexPath(item: 0, section: 1)
            let reminderCell = tableView.cellForRow(at: reminderIndexPath) as! NewTaskReminderCell
            reminderCell.isEnabled.setOn(timeReminder, animated: true)
            
            
            //date cell
            let dateIndexPath = IndexPath(item: 1, section: 1)
            let timeCell = tableView.cellForRow(at: dateIndexPath) as! NewTaskDateAndTimeCell
            timeCell.setCenterConstraints(show: dateReminder)
            tableView.reloadRows(at: [dateIndexPath], with: .fade)
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

extension TaskViewController: NewTaskPriorityCellDelegate{
    
    func prioritySwitchClicked() {
        isPriorityEnabled.toggle()
        
        let indexPath = IndexPath(item: 0, section: 4)
        let cell = tableView.cellForRow(at: indexPath) as! NewTaskPriorityCell
        cell.prioritySwicth.setOn(isPriorityEnabled, animated: true)
        
        tableView.reloadRows(at: [IndexPath(item: 1, section: 4)], with: .fade)
    }
    
}

extension TaskViewController: NewTaskDetailCellDelegate{
    
    func textFieldDidEndEditing(with text: String, and cell: DescriptionCell) {
        switch cell {
        case .title:
            task.title = text
        case .detail:
            task.details = text
        }
    }
    
}
