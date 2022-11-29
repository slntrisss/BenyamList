//
//  StatisticsCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit

class StatisticsCell: UITableViewCell {
    
    @IBOutlet weak var statisticsCollectionView: UICollectionView!
    
    static let identifier = "StatisticsCell"
    
    var statistics = [Statistics]()

    override func awakeFromNib() {
        super.awakeFromNib()
        statisticsCollectionView.dataSource = self
        statisticsCollectionView.delegate = self
        statisticsCollectionView.register(StatisticsCollectionViewCell.nib(), forCellWithReuseIdentifier: StatisticsCollectionViewCell.identifier)
        statisticsCollectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configue(with statistics:[Statistics]){
        self.statistics = statistics
    }
    
}

extension StatisticsCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCollectionViewCell.identifier, for: indexPath) as! StatisticsCollectionViewCell
        cell.configure(with: statistics[indexPath.row])
        return cell
    }
    
    func setupCollectionViewLayout() -> UICollectionViewCompositionalLayout{
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
