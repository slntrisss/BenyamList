//
//  MainViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit

class MainViewController: UITableViewController {
    
    let database = Database.shared
    
    var selectedTaskListIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StatisticsCell.nib(), forCellReuseIdentifier: StatisticsCell.identifier)
        tableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.register(TaskHeaderView.nib(), forHeaderFooterViewReuseIdentifier: TaskHeaderView.identifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add List", style: .done, target: self, action: #selector(didTapAddListButton))
    }
    
    
    
    @objc private func didTapAddListButton(){
        let vc = NewListViewController()
        vc.modalPresentationStyle = .popover
        vc.newTaskListDelegate = self
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view did appear")
        reload()
    }
    
    private func reload(){
        let sections = IndexSet(integersIn: 0..<2)
        tableView.reloadSections(sections, with: .none)
        if let selectedTaskListIndex = selectedTaskListIndex {
            tableView.reloadRows(at: [IndexPath(item: selectedTaskListIndex, section: 2)], with: .fade)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 60
        }
        return 10
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }
        else{
            return Database.shared.taskLists.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.identifier, for: indexPath) as! StatisticsCell
            let statistics = database.statistics
            cell.configue(with: statistics)
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.identifier, for: indexPath) as! CardTableViewCell
            cell.cardCellDelegate = self
            let cards = database.cards
            cell.configure(with: cards)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
            let taskLists = database.taskLists
            cell.configure(with: taskLists[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 100
        }
        
        else if indexPath.section == 1 {
            return 300
        }
        
        return 80
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskHeaderView.identifier) as! TaskHeaderView
        }
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            selectedTaskListIndex = indexPath.row
            let taskLists = database.taskLists
            let taskListVC = TaskListTableViewController()
            taskListVC.index = indexPath.row
            taskListVC.title = taskLists[indexPath.row].category.name
            taskListVC.category = taskLists[indexPath.row].category
            self.navigationController?.pushViewController(taskListVC, animated: true)
        }
    }

}

extension MainViewController: NewTaskList, CardCellProtocol{
    func cardCellPressed(_ row: Int) {
        if row == 2{
            let taskListVC = TaskListViewController()
            taskListVC.title = "All"
            self.navigationController?.pushViewController(taskListVC, animated: true)
        }
    }
    
    func saveTaskList(_ taskList: TaskList) {
        let category = taskList.category
        database.taskLists.append(taskList)
        database.allCategories.append(category)
        let index = database.taskLists.count - 1
        let indexPath = IndexPath(item: index, section: 2)
        tableView.insertRows(at: [indexPath], with: .fade)
    }
}
