//
//  TaskCollectionViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 18.01.2023.
//

import UIKit

class TaskCollectionViewController: UIViewController {
    
    var sectionTitles: [String] = []
    var taskLists:[[Task]] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension TaskCollectionViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.configure(with: taskLists[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteTasks(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AppState.shared.stateHasChanged()
        }
    }
}

extension TaskCollectionViewController{
    private func deleteTasks(at indexPath: IndexPath){
        let section = indexPath.section
        let index = indexPath.row
        let database = Database.shared
        
        let task = taskLists[section].remove(at: index)
        
        if let index = database.allTasks.firstIndex(where: {$0.id == task.id}){
            database.allTasks.remove(at: index)
        }
        
        for (i, taskList) in database.taskLists.enumerated(){
            if let index = taskList.tasks.firstIndex(where: {$0.id == task.id}){
                database.taskLists[i].tasks.remove(at: index)
            }
        }
    }
}
