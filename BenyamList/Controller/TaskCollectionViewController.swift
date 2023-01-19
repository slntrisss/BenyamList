//
//  TaskCollectionViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 18.01.2023.
//

import UIKit

class TaskCollectionViewController: UIViewController {
    
    var sectionTitles: [String] = []
    var taskLists = [[Task]]()
    var type: CollectionStyle = .Today
    let database = Database.shared
    
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
        
        if type == .Today || type == .Scheduled{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.and.pencil.and.ellipsis"), style: .done, target: self, action: #selector(editButtonPressed))
            getScheduleData()
        }else{
            getMissedData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func editButtonPressed(){
        let alert = UIAlertController(title: "Info...", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sort", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
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
        if type == .Missed{
            cell.isUserInteractionEnabled = false
        }
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
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .Missed{
            return
        }
        let index = indexPath.row
        let section = indexPath.section
        let taskDetailVC = TaskViewController()
        taskDetailVC.title = "Details"
        taskDetailVC.task = taskLists[section][index]
        let navBar = UINavigationController(rootViewController: taskDetailVC)
        navBar.modalPresentationStyle = .popover
        taskDetailVC.delegate = self
        taskDetailVC.taskType = .old
        present(navBar, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TaskCollectionViewController: TaskViewControllerDelegate{
    func updateTask(updatedTask: Task) {
        print("About to update")
        let database = Database.shared
        
        if let index = database.allTasks.firstIndex(where: {$0.id == updatedTask.id}){
            database.allTasks[index] = updatedTask
        }
        
        for (i, taskList) in database.taskLists.enumerated(){
            if let index = taskList.tasks.firstIndex(where: {$0.id == updatedTask.id}){
                database.taskLists[i].tasks[index] = updatedTask
                break
            }
        }
        reload()
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
        reload()
    }
}




extension TaskCollectionViewController{
    //MARK: - Schedule/Today
    
    private func getScheduleData() {
        taskLists = [[Task]]()
        sectionTitles = []
        let calendar = Calendar.current
        func getData() -> [Date: [Task]]{
            var dateMap = [Date: [Task]]()
            let tasks = database.allTasks
            for task in tasks {
                if let deadline = task.deadline{
                    if (type == .Scheduled && deadline >= calendar.startOfDay(for: Date.now)) ||
                        (type == .Today && calendar.isDateInToday(deadline)) {
                        if var taskList = dateMap[deadline]{
                            taskList.append(task)
                            dateMap[deadline] = taskList
                        }else{
                            var taskList = [Task]()
                            taskList.append(task)
                            dateMap[deadline] = taskList
                        }
                    }
                }
            }
            
            return dateMap
        }
        
        let data = getData().sorted(by: {$0.key < $1.key })
        var dates: Set<String> = []
        var index = -1
        data.forEach { (date: Date, tasks: [Task]) in
            let formattedDate: String
            switch self.type{
            case .Today:
                let components = calendar.dateComponents([.hour], from: date)
                guard let hour = components.hour else{
                    print("Today collection time conversion error")
                    return
                }
                if hour < 10 {
                    formattedDate = "0\(date.formatted(date: .omitted, time: .shortened))"
                }else{
                    formattedDate = date.formatted(date: .omitted, time: .shortened)
                }
            default:
                if calendar.isDateInToday(date){
                    formattedDate = "Today"
                }
                else if calendar.isDateInTomorrow(date){
                    formattedDate = "Tomorrow"
                }
                else{
                    formattedDate = date.formatted(date: .abbreviated, time: .omitted)
                }
            }
            
            if dates.contains(formattedDate){
                taskLists[index] += tasks
            }else{
                sectionTitles.append(formattedDate)
                taskLists.append(tasks)
                index += 1
                dates.insert(formattedDate)
            }
        }
        
    }
    
    //MARK: - Missed
    private func getMissedData() {
        taskLists = [[Task]]()
        sectionTitles = []
        let calendar = Calendar.current
        func getData() -> [Category: [Task]]{
            var categoryMap: [Category: [Task]] = [:]
            
            for task in database.allTasks{
                if let deadline = task.deadline, deadline < calendar.startOfDay(for: Date.now){
                    if var taskList = categoryMap[task.category]{
                        taskList.append(task)
                        categoryMap[task.category] = taskList
                    }else{
                        var taskList = [Task]()
                        taskList.append(task)
                        categoryMap[task.category] = taskList
                    }
                }
            }
            return categoryMap
            
        }
        
        let data = getData().sorted(by: {$0.key.name < $1.key.name})
        
        data.forEach { (key: Category, values: [Task]) in
            sectionTitles.append(key.name)
            taskLists.append(values)
        }
    }
    
    //MARK: - Reload TableView
    private func reload(){
        if type == .Scheduled || type == .Today{
            getScheduleData()
            tableView.reloadData()
        }
        else{
            getMissedData()
            tableView.reloadData()
        }
        AppState.shared.stateHasChanged()
    }
}

enum CollectionStyle{
    case Scheduled, Today, Missed
}
