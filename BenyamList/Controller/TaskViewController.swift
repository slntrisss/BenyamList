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
    
    private var headerViewTitles = ["Detail", "Date", "Time", "Category"]
    private var dateReminder = false
    private var timeReminder = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(dismissViewController))
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewTaskDetailCell.self, forCellReuseIdentifier: NewTaskDetailCell.identifier)
        tableView.register(NewTaskDateAndTimeCell.self, forCellReuseIdentifier: NewTaskDateAndTimeCell.identifier)
        tableView.register(NewTaskReminderCell.self, forCellReuseIdentifier: NewTaskReminderCell.identifier)
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func dismissViewController(){
        dismiss(animated: true)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskDetailCell.identifier, for: indexPath) as! NewTaskDetailCell
            indexPath.row == 0 ? cell.configure(with: "Task Name") : cell.configure(with: "Description")
            return cell
        }
        else if indexPath.section == 1{
            if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskDateAndTimeCell.identifier, for: indexPath) as! NewTaskDateAndTimeCell
                cell.configure(with: "Select a date", datePickerMode: .date)
                cell.setCenterConstraints(show: dateReminder)
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
                return cell
            }
            else if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: NewTaskReminderCell.identifier, for: indexPath) as! NewTaskReminderCell
                cell.configure(with: .time)
                cell.delegate = self
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
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 {
            return nil
        }
        return headerViewTitles[section]
    }
}

extension TaskViewController: NewTaskReminderCellDelegate{
    func switchIsCliked(in cell: DateOrTimeCell) {
        switch cell {
        case .date:
            dateReminder.toggle()
            handleDateReminder()
        case .time:
            timeReminder.toggle()
            handleTimeRemainder()
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
