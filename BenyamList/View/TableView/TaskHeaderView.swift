//
//  TaskHeaderView.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 30.11.2022.
//

import UIKit

class TaskHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var taskHeaderLabel: UILabel!
    
    static let identifier = "TaskHeaderView"
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}
