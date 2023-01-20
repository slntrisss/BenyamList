//
//  WeekCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 01.12.2022.
//

import UIKit

class WeekCell: UICollectionViewCell {
    
    static let identifier = "WeekCell"
    
    private var weekDays: WeekDays?
    private var index: Int?
    
    override var isSelected: Bool{
        didSet{
            checkIfSelected()
        }
    }
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()
    
    private let dayOfTheMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private var dayOfTheWeek: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5

        self.contentView.addSubview(stackView)
        [dayOfTheWeek, dayOfTheMonth].forEach{stackView.addArrangedSubview($0)}

        //stackview
        stackView.anchor(leading: self.contentView.leadingAnchor, top: self.contentView.topAnchor, trailing: self.contentView.trailingAnchor, bottom: self.contentView.bottomAnchor)
        
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ weekDays: WeekDays, _ index: Int){
        self.weekDays = weekDays
        self.index = index
        if Date.now.getDayOfTheMonth() == weekDays.weekDate[index].getDayOfTheMonth(){
            backgroundColor = UIColor.systemBlue
            dayOfTheWeek.textColor = .white
            dayOfTheMonth.textColor = .white
        }
        dayOfTheMonth.text = weekDays.weekDate[index].getDayOfTheMonth()
        dayOfTheWeek.text = weekDays.daysOfTheWeek[index]
    }
    
    private func checkIfSelected(){
        guard let index = index, let date = self.weekDays?.weekDate[index] else {
            print("Error getting selected date")
            return
        }

        var userInfo:[String: Date] = [:]
        userInfo["date"] = date
        NotificationCenter.default.post(name: NSNotification.Name("com.benyam.BenyamList.dateSelected"), object: nil, userInfo: userInfo)
        
        if let weekDays = self.weekDays,
           Date.now.getDayOfTheMonth() == weekDays.weekDate[index].getDayOfTheMonth(){
            return
        }
        
        if isSelected{
            backgroundColor = .hexStringToUIColor(hex: "#FFA400")
            dayOfTheWeek.textColor = .darkGray
            dayOfTheMonth.textColor = .black
        }
        else{
            backgroundColor = .systemGray5
            dayOfTheWeek.textColor = .systemGray
            dayOfTheMonth.textColor = .darkGray
        }
    }
}
