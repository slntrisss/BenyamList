//
//  TaskListTableViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 11.01.2023.
//

import UIKit

class MainListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var index: Int!
    var category: Category!
    let database = Database.shared
    var taskList: TaskList!
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllTaskTableViewCell.nib(), forCellReuseIdentifier: AllTaskTableViewCell.identifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), style: .done, target: self, action: #selector(editButtonPressed))
    }
    
    @objc func editButtonPressed(){
        let alert = UIAlertController(title: "Info...", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Show List Info", style: .default, handler: {[weak self] _ in
            let vc = NewListViewController()
            vc.modalPresentationStyle = .popover
            vc.newTaskListDelegate = self
            vc.taskList = self?.taskList
            self?.present(UINavigationController(rootViewController: vc), animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Add task", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else {
                print("Error of conversion of self to strong")
                return
            }
            let task = Task(title: "", category: strongSelf.category)
            let newTaskVC = TaskViewController()
            newTaskVC.title = "New Task"
            newTaskVC.task = task
            let navBar = UINavigationController(rootViewController: newTaskVC)
            navBar.modalPresentationStyle = .popover
            newTaskVC.delegate = self
            newTaskVC.taskType = .new
            strongSelf.present(navBar, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Sort", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete Task List", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else{
                print("Error deleting task list in Main TaskListView")
                return
            }
            let database = strongSelf.database
            let index = strongSelf.index ?? 0
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
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.taskLists[index].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllTaskTableViewCell.identifier, for: indexPath) as! AllTaskTableViewCell
        cell.showCategoryLabel = false
        cell.configure(with: database.taskLists[index].tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let taskDetailVC = TaskViewController()
        taskDetailVC.title = "Details"
        taskDetailVC.task = database.taskLists[index].tasks[indexPath.row]
        let navBar = UINavigationController(rootViewController: taskDetailVC)
        navBar.modalPresentationStyle = .popover
        taskDetailVC.delegate = self
        taskDetailVC.taskType = .old
        present(navBar, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension MainListTableViewController: TaskViewControllerDelegate{
    
    func addTask(task: Task) {
        let database = Database.shared
        database.taskLists[index].tasks.append(task)
        database.allTasks.append(task)
        
        let lastIndex = database.taskLists[index].tasks.endIndex - 1
        let indexPath = IndexPath(item: lastIndex, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        AppState.shared.stateHasChanged()
    }
    
    func updateTask(updatedTask: Task) {
        upToDate(updatedTask: updatedTask)
        tableView.reloadData()
        AppState.shared.stateHasChanged()
    }
    
    private func upToDate(updatedTask: Task){
        if let allTaskIndex = Database.shared.allTasks.firstIndex(where: {updatedTask.id == $0.id}){
            Database.shared.allTasks[allTaskIndex] = updatedTask
        }
        let taskLists = Database.shared.taskLists
        for i in taskLists.indices {
            if let index = taskLists[i].tasks.firstIndex(where: {updatedTask.id == $0.id}){
                Database.shared.taskLists[i].tasks[index] = updatedTask
                return
            }
        }
    }
    
}

extension MainListTableViewController: NewTaskListDelegate{
    func saveTaskList(_ taskList: TaskList) {
        
        for (i, task) in database.allTasks.enumerated(){
            if task.category.name == self.category.name{
                database.allTasks[i].category = taskList.category
            }
        }
        
        for (i, list) in database.taskLists.enumerated(){
            if list.category.name == self.category.name{
                database.taskLists[i] = TaskList(category: taskList.category, tasks: list.tasks)
                for j in database.taskLists[i].tasks.indices{
                    database.taskLists[i].tasks[j].category = taskList.category
                }
            }
        }
        
        for (i, category) in database.allCategories.enumerated(){
            if category.name == self.category.name{
                database.allCategories[i] = taskList.category
            }
        }
        
        AppState.shared.stateHasChanged()
        self.title = taskList.category.name
    }
}
