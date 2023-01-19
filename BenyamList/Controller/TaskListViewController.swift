//
//  TaskListViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 01.12.2022.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Views
    
    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    let database = Database.shared
    var tasks: [Task] = []
    var selectedCategory: Category?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DateViewCell.self, forCellReuseIdentifier: DateViewCell.identifier)
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.identifier)
        tableView.register(AllTaskTableViewCell.nib(), forCellReuseIdentifier: AllTaskTableViewCell.identifier)
        
        tasks = database.allTasks
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name(AppState.reorderedCollectionName), object: nil)
        
        //addSubviews
        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor, top: view.topAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Task",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(addNewTask))
        
    }
    
    @objc func addNewTask(){
        let newTaskVC = TaskViewController()
        let navBar = UINavigationController(rootViewController: newTaskVC)
        newTaskVC.title = "New Task"
        newTaskVC.taskType = .new
        newTaskVC.delegate = self
        newTaskVC.task = Task(title: "", deadline: nil)
        navBar.modalPresentationStyle = .popover
        present(navBar, animated: true)
    }
    
    @objc func updateTableView(){
        if let selectedCategory = selectedCategory {
            self.categorySelected(category: selectedCategory)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1;
        }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DateViewCell.identifier, for: indexPath) as! DateViewCell
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
            let categories = database.allCategories
            cell.categories = categories
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: AllTaskTableViewCell.identifier, for: indexPath) as! AllTaskTableViewCell
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.height * 0.3
        }
        else if indexPath.section == 1{
            return 60
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            let taskDetailVC = TaskViewController()
            taskDetailVC.title = "Details"
            taskDetailVC.task = tasks[indexPath.row]
            let navBar = UINavigationController(rootViewController: taskDetailVC)
            navBar.modalPresentationStyle = .popover
            taskDetailVC.delegate = self
            taskDetailVC.taskType = .old
            present(navBar, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && editingStyle == .delete{
            deleteTask(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AppState.shared.stateHasChanged()
        }
    }
}

extension TaskListViewController{
    //delete task
    private func deleteTask(at indexPath: IndexPath){
        tasks.remove(at: indexPath.row)
        let cell = tableView.cellForRow(at: indexPath) as! AllTaskTableViewCell
        let task = cell.task
        if let index = database.allTasks.firstIndex(where: {$0.id == task?.id}){
            database.allTasks.remove(at: index)
        }
        for i in database.taskLists.indices{
            if let index = database.taskLists[i].tasks.firstIndex(where: {$0.id == task?.id}){
                database.taskLists[i].tasks.remove(at: index)
                return
            }
        }
        AppState.shared.stateHasChanged()
    }
}

extension TaskListViewController: TaskViewControllerDelegate{
    
    func updateTask(updatedTask: Task) {
        //Current view tasks
        if let index = tasks.firstIndex(where: {$0.id == updatedTask.id}){
            tasks[index] = updatedTask
        }
        
        //All tasks
        if let index = database.allTasks.firstIndex(where: {$0.id == updatedTask.id}){
            database.allTasks[index] = updatedTask
        }
        
        //TaskList
        let taskLists = database.taskLists
        for i in taskLists.indices {
            let taskCategoryName = updatedTask.category.name.lowercased().trimmingCharacters(in: .whitespaces)
            let taskListCategoryName = taskLists[i].category.name.lowercased().trimmingCharacters(in: .whitespaces)
            
            if taskCategoryName == taskListCategoryName{
                if let index = taskLists[i].tasks.firstIndex(where: {updatedTask.id == $0.id}){
                    database.taskLists[i].tasks[index] = updatedTask
                    break;
                }
            }
        }
        
        let index = tasks.count - 1
        let indexPath = IndexPath(item: index, section: 2)
        tableView.reloadRows(at: [indexPath], with: .fade)
        AppState.shared.reorderSortedCollection()
        AppState.shared.stateHasChanged()
    }
    
    func addTask(task: Task) {
        tasks.append(task)
        database.allTasks.append(task)
        let taskLists = database.taskLists
        
        for i in taskLists.indices {
            let taskCategoryName = task.category.name.lowercased().trimmingCharacters(in: .whitespaces)
            let taskListCategoryName = taskLists[i].category.name.lowercased().trimmingCharacters(in: .whitespaces)
            
            if taskCategoryName == taskListCategoryName{
                database.taskLists[i].tasks.append(task)
            }
        }
        
        let lastIndex = tasks.endIndex - 1
        let indexPath = IndexPath(item: lastIndex, section: 2)
        tableView.insertRows(at: [indexPath], with: .fade)
        AppState.shared.reorderSortedCollection()
        AppState.shared.stateHasChanged()
    }
}

extension TaskListViewController: CategoryViewCellDelegate{
    func categorySelected(category: Category) {
        if category.name == "All"{
            tasks = database.allTasks
            self.selectedCategory = category
        }else{
            self.selectedCategory = category
            let allTasks = database.allTasks
            tasks = []
            let categoryName = category.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            for task in allTasks {
                let taskCategoryName = task.category.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                if taskCategoryName == categoryName{
                    tasks.append(task)
                }
            }
        }
        tableView.beginUpdates()
        tableView.reloadSections(IndexSet(integer: 2), with: .fade)
        tableView.endUpdates()
    }
}


