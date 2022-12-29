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
    
    var tasks: [Task]!
    var categories: [Category]!

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
        categories.insert(Category(name: "All", color: .dodgerBlue), at: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Task",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(addNewTask))
        
    }
    
    @objc func addNewTask(){
        let newTaskVC = TaskViewController()
        let navBar = UINavigationController(rootViewController: newTaskVC)
        newTaskVC.title = "New Task"
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
