//
//  StatisticsCollectionViewCell.swift
//  BenyamList
//
//  Created by Raiymbek Merekeyev on 29.11.2022.
//

import UIKit
import Charts
class StatisticsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var progressType: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var progressBackgroundView: UIView!
    
    var statistics:Statistics!
    
    static let identifier = "StatisticsCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        progressBackgroundView.layer.cornerRadius = 5
        progressBackgroundView.clipsToBounds = true
        
    }
    
    static func nib() -> UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with statistics: Statistics){
        self.statistics = statistics
        title.text = "Keep it up!"
        subTitle.text = "Your current progress"
        progressType.text = statistics.type.rawValue
        if statistics.totalNumberOfTasks == 0 {
            title.isHidden = true
            chartView.isHidden = true
            progressBackgroundView.isHidden = true
            subTitle.text = "Woohoo, no task due \(statistics.type == .overall ? "soon" : "today")!"
            subTitle.textColor = .systemGray
            subTitle.font = .systemFont(ofSize: 17, weight: .bold)
        }else{
            title.isHidden = false
            chartView.isHidden = false
            progressBackgroundView.isHidden = false
            subTitle.textColor = .black
            subTitle.font = .systemFont(ofSize: 14, weight: .regular)
            setupPieChartView()
        }
    }

}

extension StatisticsCollectionViewCell{
    private func setupPieChartView(){
        guard let statistics = statistics else {
            return
        }
        let leftTasks = statistics.totalNumberOfTasks - statistics.completedNumberOfTasks
        chartView.chartDescription.enabled = false
        chartView.rotationAngle = -135
        chartView.rotationEnabled = false
        chartView.isUserInteractionEnabled = false
        chartView.legend.enabled = false
        chartView.transparentCircleRadiusPercent = 0
        chartView.holeRadiusPercent = 0.9
        var entries: [PieChartDataEntry] = []
        entries.append(PieChartDataEntry(value: Double(leftTasks)))
        entries.append(PieChartDataEntry(value: Double(statistics.completedNumberOfTasks)))
        chartView.centerAttributedText = createCenteredPieChartText()
        
        let dataset = PieChartDataSet(entries: entries)
        dataset.drawValuesEnabled = false
        dataset.colors = [
            NSUIColor(red: CGFloat(214) / 255.0, green: CGFloat(214) / 255.0, blue: CGFloat(214) / 255.0, alpha: CGFloat(1.0)),
            NSUIColor(red: CGFloat(48) / 255.0, green: CGFloat(229) / 255.0, blue: CGFloat(98) / 255.0, alpha: CGFloat(1))
        ]
        
        chartView.data = PieChartData(dataSet: dataset)
    }
    
    private func createCenteredPieChartText() -> NSMutableAttributedString {
        guard let statistics = statistics else{
            fatalError("Error getting statistics data")
        }
        let percentage = getPercentage(val1: Double(statistics.totalNumberOfTasks), val2: Double(statistics.completedNumberOfTasks))
        let percentageStr = String(format: "%.f", percentage)
        
        //percentage
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes1: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor(red: CGFloat(38) / 255.0, green: CGFloat(196.0) / 255.0, blue: CGFloat(75.0) / 255.0, alpha: CGFloat(1.0)),
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
            ]
        let progressLabel = NSMutableAttributedString(string: percentageStr, attributes: attributes1)
        
        let percentLabel = "%"
        let attributes2: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor(red: CGFloat(38) / 255.0, green: CGFloat(196.0) / 255.0, blue: CGFloat(75.0) / 255.0, alpha: CGFloat(1.0)),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
            ]
        let percentIcon = NSMutableAttributedString(string: percentLabel, attributes: attributes2)
        progressLabel.append(percentIcon)
        
        
        return progressLabel
    }
    
    private func getPercentage(val1:Double, val2:Double) -> Double{
        return (val2 * 100) / val1;
    }
}
