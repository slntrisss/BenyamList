//
//  WeekCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 01.12.2022.
//

import UIKit

class WeekCell: UICollectionViewCell {
    
    static let identifier = "WeekCell"
    
    var weekViewWidth: CGFloat!
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = CGFloat(8)
        return stackView
    }()
    
    private let dayOfTheMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    private var dayOfTheWeek: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5

        self.contentView.addSubview(stackView)
        [dayOfTheMonth, dayOfTheWeek].forEach{stackView.addArrangedSubview($0)}

        //stackview
        stackView.anchor(leading: self.contentView.leadingAnchor, top: self.contentView.topAnchor, trailing: self.contentView.trailingAnchor, bottom: self.contentView.bottomAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ weekDays: WeekDays, _ index: Int){
        dayOfTheMonth.text = weekDays.weekDate[index].getDayOfTheMonth()
        dayOfTheWeek.text = weekDays.daysOfTheWeek[index]
    }
}
