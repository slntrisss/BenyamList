//
//  MainViewController.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit
class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        tableView.register(StatisticsCell.nib(), forCellReuseIdentifier: StatisticsCell.identifier)
    }
    
    var statistics = [Statistics]()
    var cards = [Card]()
    var taskLists = [TaskList]()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }else{
            return taskLists.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.identifier, for: indexPath) as! StatisticsCell
            cell.configue(with: statistics)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsCell.identifier, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        else if indexPath.section == 1{
            return 300
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

}
