//
//  DateViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 01.12.2022.
//

import UIKit
import FSCalendar

class DateViewCell: UITableViewCell {
    
    static let identifier = "DateViewCell"
    
    private var segmentedControll: UISegmentedControl = {
        let items = ["Month", "Week"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private var calendarView : UIView = {
        let calendar = FSCalendar()
        calendar.scrollDirection = .horizontal
        calendar.backgroundColor = .systemGray5
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    private var weekView: UIView = {
        
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        [segmentedControll, calendarView].forEach{self.contentView.addSubview($0)}
        setupViewContraints()
    }
    
    private func setupViewContraints(){
        // calendar
        calendarView.frame = CGRect(x: 0, y: contentView.height * 0.1 + 20, width: contentView.width, height: contentView.height * 0.8)
        calendarView.layer.cornerRadius = 12
        
        //segmented controll
        segmentedControll.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        segmentedControll.sizeAnchor(width: 150, height: 30)
    }
    
}
