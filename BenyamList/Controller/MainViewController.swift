//
//  MainViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit

class MainViewController: UITableViewController {
    
    let database = Database.shared
    
    var appStateChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StatisticsCell.nib(), forCellReuseIdentifier: StatisticsCell.identifier)
        tableView.register(CardTableViewCell.nib(), forCellReuseIdentifier: CardTableViewCell.identifier)
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.register(TaskHeaderView.nib(), forHeaderFooterViewReuseIdentifier: TaskHeaderView.identifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add List", style: .done, target: self, action: #selector(didTapAddListButton))
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeAppState), name: NSNotification.Name(AppState.name), object: nil)
    }
    
    
    
    @objc private func didTapAddListButton(){
        let vc = NewListViewController()
        vc.modalPresentationStyle = .popover
        vc.newTaskListDelegate = self
        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func changeAppState(){
        appStateChanged = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func reload(){
        if appStateChanged{
            tableView.reloadData()
            appStateChanged.toggle()
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
            return database.taskLists.count
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
            let taskLists = database.taskLists
            let taskListVC = MainListTableViewController()
            taskListVC.index = indexPath.row
            taskListVC.title = taskLists[indexPath.row].category.name
            taskListVC.category = taskLists[indexPath.row].category
            self.navigationController?.pushViewController(taskListVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && editingStyle == .delete {
            let index = indexPath.row
            deleteTaskList(at: index)
            tableView.reloadData()
        }
    }

}

extension MainViewController{
    //Delete tasklist
    private func deleteTaskList(at index: Int){
        let tasks = database.taskLists[index].tasks
        let allTasks = database.allTasks
        var taskMap: [UUID: Task] = [:]
        
        for task in allTasks {
            taskMap[task.id] = task
        }
        for task in tasks {
            if taskMap[task.id] != nil{
                taskMap[task.id] = nil
            }
        }
        database.allTasks = Array(taskMap.values)
        database.taskLists.remove(at: index)
        database.allCategories.remove(at: index)
    }
}

extension MainViewController: NewTaskList, CardCellProtocol{
    func cardCellPressed(_ row: Int) {
        if row == 0{
            let collectionVC = TaskCollectionViewController()
            collectionVC.title = "Scheduled"
            collectionVC.type = .Scheduled
            self.navigationController?.pushViewController(collectionVC, animated: true)
        }
        else if row == 1{
            let collectionVC = TaskCollectionViewController()
            collectionVC.title = "Today"
            collectionVC.type = .Today
            self.navigationController?.pushViewController(collectionVC, animated: true)
        }
        else if row == 2{
            let taskListVC = TaskListViewController()
            taskListVC.title = "All"
            if database.allCategories.count > 0{
                taskListVC.selectedCategory = database.allCategories[0]
            }
            self.navigationController?.pushViewController(taskListVC, animated: true)
        }
        else{
            let collectionVC = TaskCollectionViewController()
            collectionVC.title = "Missed"
            collectionVC.type = .Missed
            self.navigationController?.pushViewController(collectionVC, animated: true)
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
