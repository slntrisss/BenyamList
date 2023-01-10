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
    
    var tasks = Database.shared.allTasks
    var categories = Database.shared.allCategories

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DateViewCell.self, forCellReuseIdentifier: DateViewCell.identifier)
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.identifier)
        tableView.register(AllTaskTableViewCell.nib(), forCellReuseIdentifier: AllTaskTableViewCell.identifier)
        
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
            cell.categories = categories
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
}

extension TaskListViewController: TaskViewControllerDelegate{
    
    func updateTask(updatedTask: Task) {
        if let index = tasks.firstIndex(where: { task in
            task.id == updatedTask.id
        }){
            tasks[index] = updatedTask
            Database.shared.allTasks[index] = updatedTask
            tableView.reloadRows(at: [IndexPath(item: index, section: 2)], with: .fade)
        }
    }
    
    func addTask(task: Task) {
        tasks.append(task)
        Database.shared.allTasks.append(task)
        
        let lastIndex = tasks.endIndex - 1
        let indexPath = IndexPath(item: lastIndex, section: 2)
        tableView.insertRows(at: [indexPath], with: .fade)
    }
}
