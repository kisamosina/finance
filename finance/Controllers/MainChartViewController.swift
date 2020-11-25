//
//  MainChartViewController.swift
//  finance
//
//  Created by mac on 05/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit
import Charts

class MainChartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logSegmentedControl: UISegmentedControl!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    fileprivate var selectedRow: Int?

    var categories = [String]()
    var transactionsToDisplay = RealmManager.shared.transactions
    let todayStart = Calendar.current.startOfDay(for: Date())

    @IBOutlet weak var pieChartView: PieChartView!
    
    public func customizeChart(dataPoints: [String], values: [Double]) {
        
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
    public func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
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
    
    func getCategoriesSums(categories: [String], transactions: [Transaction]) -> [Double] {
        var arrayOfSums = [Double]()

        for categoryName in categories {
            let result = transactions.reduce(0, {result, transaction in
                transaction.category == categoryName ? result + transaction.value : result
            })
            result > 0 ? arrayOfSums.append(Double(result)) : arrayOfSums.append(-Double(result))

        }
        return arrayOfSums
    }
    
    func getAllValuesForCategory() -> [Double] {
        let arrayOfTransactions = Array(transactionsToDisplay)
        let finalTransactionsArray = arrayOfTransactions.map {Transaction(id: $0.id, date: $0.date, category: $0.category, value:$0.value, name:$0.name, icon: $0.icon)}
        let finalValues = getCategoriesSums(categories: categories, transactions: finalTransactionsArray)
        return finalValues
        
    }
    

    @objc fileprivate func handleLogSegmentedControl() {
        switch logSegmentedControl.selectedSegmentIndex {
        case 0:
            transactionsToDisplay = RealmManager.shared.transactions.filter("value < 0")
          
        default:
            transactionsToDisplay = RealmManager.shared.transactions.filter("value > 0")
        }
        tableView.reloadData()
        
        categories = transactionsToDisplay.map {$0.category}.removingDuplicates()
        customizeChart(dataPoints: categories, values: getAllValuesForCategory())

    }
    
    
    
    @objc fileprivate func handlePeriodSegmentedControl() {
        print(periodSegmentedControl.selectedSegmentIndex)
        
        switch periodSegmentedControl.selectedSegmentIndex {
        case 0:
//            Week
            if logSegmentedControl.selectedSegmentIndex == 0 {
            
            let todayEndWeek: Date = {
                return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
            }()
                
            transactionsToDisplay = transactionsToDisplay.filter("value < 0 AND date BETWEEN %@", [todayEndWeek, todayStart])
                
            } else {

                let todayEndWeek: Date = {
                    return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
                }()
 
                transactionsToDisplay = transactionsToDisplay.filter("value > 0 AND date BETWEEN %@", [todayEndWeek, todayStart])
            }
    
        case 1:
//            Month
            if logSegmentedControl.selectedSegmentIndex == 0 {
            let weekStart = Calendar.current.startOfDay(for: Date())
            let weekEnd: Date = {
                return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            }()
            
            transactionsToDisplay = transactionsToDisplay.filter("value < 0 AND date BETWEEN %@", [weekEnd, weekStart])
            } else {

                let todayEnd: Date = {
                    return Calendar.current.date(byAdding: .month, value: -1, to: Date())!
                }()
                
                transactionsToDisplay = transactionsToDisplay.filter("value > 0 AND date BETWEEN %@", [todayEnd, todayStart])
            }
        default:
//            All
            if logSegmentedControl.selectedSegmentIndex == 0 {
            transactionsToDisplay = RealmManager.shared.transactions.filter("value < 0")
            } else {
            transactionsToDisplay = RealmManager.shared.transactions.filter("value > 0")
            }
        }
        tableView.reloadData()
        categories = transactionsToDisplay.map {$0.category}.removingDuplicates()
        customizeChart(dataPoints: categories, values: getAllValuesForCategory())
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        logSegmentedControl.addTarget(self, action: #selector(handleLogSegmentedControl), for: .valueChanged)
        logSegmentedControl.addTarget(self, action: #selector(handleLogSegmentedControl), for: .touchUpInside)
        periodSegmentedControl.addTarget(self, action: #selector(handlePeriodSegmentedControl), for: .valueChanged)
        periodSegmentedControl.addTarget(self, action: #selector(handlePeriodSegmentedControl), for: .touchUpInside)
        
//        Default
        let todayEndWeek: Date = {
            return Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        }()
            
        transactionsToDisplay = transactionsToDisplay.filter("value < 0 AND date BETWEEN %@", [todayEndWeek, todayStart])
        categories = transactionsToDisplay.map {$0.category}.removingDuplicates()
        customizeChart(dataPoints: categories, values: getAllValuesForCategory())

        }

    }


extension MainChartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return transactionsToDisplay.count
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "log") as! LogTableViewCell
        cell.nameLabel?.text = "\(transactionsToDisplay[indexPath.row].name)"
        cell.dateLabel?.text = "\(transactionsToDisplay[indexPath.row].date.getFormattedDate(format: "MMM d, yyyy"))"
        cell.valueLabel?.text = "\(Utils.priceFormatter.string(from: NSNumber(value: transactionsToDisplay[indexPath.row].value))!)"
        cell.pictureImage.image = UIImage(named: transactionsToDisplay[indexPath.row].icon)
    
        return cell
   
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row

        performSegue(withIdentifier: "category", sender: indexPath.row)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let destinationVC = segue.destination as? CategoryViewController else { return }
            let selectedRow = indexPath.row
            destinationVC.selectedCategory = transactionsToDisplay[selectedRow].category
        }
    }
}



