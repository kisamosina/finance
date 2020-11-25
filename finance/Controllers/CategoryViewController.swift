//
//  ExpenseChartViewController.swift
//  finance
//
//  Created by mac on 05/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var rowSelected : Int?
    var selectedCategory: String?
    var rowsToDisplay = RealmManager.shared.transactions
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rowsToDisplay = RealmManager.shared.transactions.filter("category == %@", selectedCategory!)
     

        
    }

}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsToDisplay.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryCell
             cell.nameLabel?.text = "\(rowsToDisplay[indexPath.row].name)"
             cell.dateLabel?.text = "\(rowsToDisplay[indexPath.row].date.getFormattedDate(format: "MMM d, yyyy"))"
             cell.valueLabel?.text = "\(Utils.priceFormatter.string(from: NSNumber(value: rowsToDisplay[indexPath.row].value))!)"
             cell.pictureImage.image = UIImage(named: rowsToDisplay[indexPath.row].icon)
         
             return cell
        
         }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "single" {
            guard let destinationVC = segue.destination as? DetailViewController else { return }
            
            destinationVC.singleCategory = selectedCategory
 
        }
    }
    }
    

