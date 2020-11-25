//
//  DetailViewController.swift
//  finance
//
//  Created by mac on 05/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class DetailViewController: UIViewController {
    
    var names = [String]()
    var singleCategory: String?
    var singleCategoryTransactions = RealmManager.shared.transactions
    
    @IBOutlet weak var perionSegmentedControl: UISegmentedControl!
    

    @IBOutlet weak var pieChartView: PieChartView!
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)

    }
        
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        pieChartDataSet.valueFont = UIFont(name:"futura",size:0)!
        pieChartDataSet.entryLabelColor = .clear
    

        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
        
    }
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
    
    func getSumForCategory(names: [String], transactions:[Transaction]) -> [Double] {
        var arrayOfSums = [Double]()
        
        for _ in names {
            let result = transactions.reduce(0, {result, transaction in
                result + transaction.value
            })
            result > 0 ? arrayOfSums.append(Double(result)) : arrayOfSums.append(-Double(result))
        }
        
        return arrayOfSums
    }
    
    func getAllValues() -> [Double] {
        let arrayOfTransactions = Array(singleCategoryTransactions)
        let finalTransactionsArray = arrayOfTransactions.map {Transaction(id: $0.id, date: $0.date, category: $0.category, value:$0.value, name:$0.name, icon: $0.icon)}
        let finalValues = getSumForCategory(names: names, transactions: finalTransactionsArray)
        return finalValues
    }
    
    public func drawChart(transactions: Results<TransactionRealm>) {
        names = transactions.map { $0.name }
        customizeChart(dataPoints: names, values: getAllValues())
    }
    
    @objc func handlePeriodSegmentedControl() {
        
        switch perionSegmentedControl.selectedSegmentIndex {
        case 0:
//            Week
            let todayStartWeek = Calendar.current.startOfDay(for: Date())
            let todayEndWeek: Date = {
                return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
            }()
            
            singleCategoryTransactions = RealmManager.shared.transactions
                .filter("category == %@ AND date BETWEEN %@", singleCategory!, [todayEndWeek, todayStartWeek])
            drawChart(transactions: singleCategoryTransactions)

            
        case 1:
//            Month
            let todayStart = Calendar.current.startOfDay(for: Date())
            let todayEnd: Date = {
                return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            }()
            
            singleCategoryTransactions = RealmManager.shared.transactions
                .filter("category == %@ AND date BETWEEN %@", singleCategory!, [todayEnd, todayStart])
           drawChart(transactions: singleCategoryTransactions)
            
        default:
//            All
            singleCategoryTransactions = RealmManager.shared.transactions
                .filter("category == %@", singleCategory!)
            drawChart(transactions: singleCategoryTransactions)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        perionSegmentedControl.addTarget(self, action: #selector(handlePeriodSegmentedControl), for: .valueChanged)
        perionSegmentedControl.addTarget(self, action: #selector(handlePeriodSegmentedControl), for: .touchUpInside)


        //        Default
        let todayStartWeek = Calendar.current.startOfDay(for: Date())
        let todayEndWeek: Date = {
            return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        }()
        
        singleCategoryTransactions = RealmManager.shared.transactions
            .filter("category == %@ AND date BETWEEN %@", singleCategory!, [todayEndWeek, todayStartWeek])
            
        drawChart(transactions: singleCategoryTransactions)
    }

}
