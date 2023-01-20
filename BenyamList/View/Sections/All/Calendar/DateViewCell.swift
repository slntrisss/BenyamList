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
    
    //WeekView
    let weekDays = WeekDays.getData()
    let minimumInterSpacing:CGFloat = 5
    let itemSpacing:CGFloat = 5
    let itemsInOneLine = 7
    
    lazy private var segmentedControll: UISegmentedControl = {
        let items = ["Month", "Week"]
        let segmentedControll = UISegmentedControl(items: items)
        segmentedControll.translatesAutoresizingMaskIntoConstraints = false
        segmentedControll.selectedSegmentIndex = 0
        segmentedControll.addTarget(self, action: #selector(changeCalendarView), for: .valueChanged)
        return segmentedControll
    }()
    
    lazy private var calendarView : UIView = {
        let calendar = FSCalendar()
        calendar.scrollDirection = .horizontal
        calendar.backgroundColor = .systemGray5
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.delegate = self
        return calendar
    }()
    
    lazy private var weekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumInterSpacing
        layout.minimumInteritemSpacing = minimumInterSpacing
        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alpha = 0
        collectionView.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.identifier)
        return collectionView
    }()
    
    lazy private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = formatDate(date: Date.now)
        label.alpha = 0
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        [calendarView, weekCollectionView, segmentedControll, dateLabel].forEach{self.contentView.addSubview($0)}
        setupViewContraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changeCalendarView(sender : UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            weekCollectionView.alpha = 0
            dateLabel.alpha = 0
            calendarView.alpha = 1
        }else{
            calendarView.alpha = 0
            weekCollectionView.alpha = 1
            dateLabel.alpha = 1
        }
    }
    
    
    //MARK: - Helper funcs
    
    private func setupViewContraints(){
        setupSegmentedControll()
        setupCalendarView()
        setupWeekView()
        setupDateLabel()
    }
    
    private func setupCalendarView(){
        calendarView.anchor(leading: self.contentView.leadingAnchor, top: self.contentView.topAnchor, trailing: self.contentView.trailingAnchor, bottom: self.contentView.bottomAnchor, padding: .init(top: segmentedControll.height + 10, left: 0, bottom: 0, right: 0))
        calendarView.layer.cornerRadius = 12
    }
    
    private func setupWeekView(){
        weekCollectionView.anchor(leading: self.contentView.leadingAnchor, top: self.contentView.topAnchor, trailing: self.contentView.trailingAnchor, bottom: nil, padding: .init(top: segmentedControll.height + 10, left: 0, bottom: 0, right: 0), size: .init(width: .zero, height: 100))
    }
    
    private func setupSegmentedControll() {
        segmentedControll.centerAnchor(centerX: self.contentView.centerXAnchor, centerY: nil, xPadding: 0, yPadding: 0)
        segmentedControll.sizeAnchor(width: 150, height: 30)
    }
    
    private func setupDateLabel(){
        dateLabel.anchor(leading: self.contentView.leadingAnchor, top: nil, trailing: self.contentView.trailingAnchor, bottom: self.contentView.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    private func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        let weekDayFormatter = DateFormatter()
        weekDayFormatter.dateFormat = "EEEE"
        formatter.dateFormat = "dd MMMM yyyy"
        return "\(formatter.string(from: date))\n\(weekDayFormatter.string(from: date))"
    }
    
}

extension DateViewCell: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        var userInfo:[String: Date] = [:]
        userInfo["date"] = date
        NotificationCenter.default.post(name: NSNotification.Name("com.benyam.BenyamList.dateSelected"), object: nil, userInfo: userInfo)
    }
}

extension DateViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDays.weekDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.identifier, for: indexPath) as! WeekCell
        cell.configure(weekDays, indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edgeSpace = itemSpacing * 2
        let interItemSpacing = CGFloat(itemsInOneLine - 1) * itemSpacing
        let width = (weekCollectionView.width - edgeSpace - interItemSpacing) / CGFloat(itemsInOneLine)
        let height:CGFloat = 80
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isSelected = true
        dateLabel.text = formatDate(date: weekDays.weekDate[indexPath.row])
    }
    
}
