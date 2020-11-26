//
//  ViewController.swift
//  finance
//
//  Created by mac on 02/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var balance: Int?

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var balanceLabel: UILabel!

    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        incomeButton.layer.isHidden = false
        expenseButton.layer.isHidden = false
        addButton.layer.isHidden = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RealmManager.shared.beginUpdate(balanceLabel)

        
        addButton.layer.cornerRadius =  0.5 * addButton.bounds.size.width
        incomeButton.layer.cornerRadius =  0.5 * incomeButton.bounds.size.width
        expenseButton.layer.cornerRadius =  0.5 * expenseButton.bounds.size.width
        
        incomeButton.layer.isHidden = true
        expenseButton.layer.isHidden = true

        tableView.reloadData()
  
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)

        tableView.reloadData()
  
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: nil)
        
        addButton.layer.isHidden = false
        incomeButton.layer.isHidden = true
        expenseButton.layer.isHidden = true
        
    }
    @IBAction func expenseButtonTapped(_ sender: Any) {

        performSegue(withIdentifier: "add", sender: sender)
   
    }
    @IBAction func incomeButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "add", sender: sender)
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
       
    }
    

}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "add" {
        
        let senderButton = sender as? UIButton
        
        switch senderButton {
        case expenseButton:
            let destination = segue.destination as? TransactionViewController
            destination?.segmentedControlIndex = 0
//            print("expense button tapped")
        case incomeButton:
            let destination = segue.destination as? TransactionViewController
            destination?.segmentedControlIndex = 1
//            print("income button tapped")
        default:
            break
            
            }
            
        }
        
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RealmManager.shared.transactions.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction") as! TransactionCell

        cell.nameLabel?.text = "\(RealmManager.shared.transactions[indexPath.row].name)"
        cell.valueLabel?.text = "\(Utils.priceFormatter.string(from: NSNumber(value: RealmManager.shared.transactions[indexPath.row].value))!)"
        cell.dateLabel?.text = "\(RealmManager.shared.transactions[indexPath.row].date.getFormattedDate(format: "MMM d, yyyy"))"
        cell.pictureImage.image = UIImage(named: RealmManager.shared.transactions[indexPath.row].icon)
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RealmManager.shared.deleteTransaction(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
  
    }
    

    
    
}

