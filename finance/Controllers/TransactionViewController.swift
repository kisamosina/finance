//
//  TransactionViewController.swift
//  finance
//
//  Created by mac on 03/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {
    

    @IBOutlet weak var dateIcon: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var userNumber = 0

    var transactionsArray = [Transaction]()
 
    var segmentedControlIndex = 0
    
    var pickedExpenseCategory: ExpenseCategory?
    var pickerIncomeCategory: IncomeCategory?

    
    
//    Category buttons
    @IBOutlet weak var donationButton: UIButton!
    @IBOutlet weak var entertainmentButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var healthButton: UIButton!
    @IBOutlet weak var shoppingButton: UIButton!
    @IBOutlet weak var transportationButton: UIButton!
    @IBOutlet weak var utilitiesButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
//    Category actions
    @IBAction func donationPicked(_ sender: Any) {
       if segmentedControlIndex == 0 {
        pickedExpenseCategory = ExpenseCategory.donation
        
        } else {
        pickerIncomeCategory = IncomeCategory.salary
        
        }
  
    }
    @IBAction func entertainmentPicked(_ sender: Any) {
        if segmentedControlIndex == 0 {
        pickedExpenseCategory = ExpenseCategory.entertainment
        } else {
        pickerIncomeCategory = IncomeCategory.gift
        }
    }
    @IBAction func foodPicked(_ sender: Any) {
        pickedExpenseCategory = ExpenseCategory.food
    }
    @IBAction func healthPicked(_ sender: Any) {
        if segmentedControlIndex == 0 {
        pickedExpenseCategory = ExpenseCategory.health
        } else {
        pickerIncomeCategory = IncomeCategory.otherIncome
        }
    }
    @IBAction func shoppingPicked(_ sender: Any) {
        pickedExpenseCategory = ExpenseCategory.shopping
    }
    @IBAction func transportationPicked(_ sender: Any) {
        pickedExpenseCategory = ExpenseCategory.transportation
    }
    @IBAction func utilitiesPicked(_ sender: Any) {
        pickedExpenseCategory = ExpenseCategory.utilities
    }
    @IBAction func educationPicked(_ sender: Any) {
        pickedExpenseCategory = ExpenseCategory.otherExpense
    }
    
    
    @IBAction func onDateTapped(_ sender: Any) {
        datePicker.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        numberTextField.keyboardType = .numberPad
//        nameTextField.keyboardType = .default
        datePicker.isHidden = true
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .touchUpInside)

//        print(Realm.Configuration.defaultConfiguration.fileURL!)

    }
//    Manage buttons
    
    func manageButtons(hidden: Bool) {
        foodButton.isHidden = hidden
        shoppingButton.isHidden = hidden
        transportationButton.isHidden = hidden
        utilitiesButton.isHidden = hidden
        otherButton.isHidden = hidden
    }
    
    func setExpenseButtonTitles() {
        donationButton.setTitle("Donation", for: .normal)
        entertainmentButton.setTitle("Entertainment", for: .normal)
        foodButton.setTitle("Food", for: .normal)
        healthButton.setTitle("Health", for: .normal)
        shoppingButton.setTitle("Shopping", for: .normal)
        transportationButton.setTitle("Transportation", for: .normal)
        utilitiesButton.setTitle("Utilities", for: .normal)
        otherButton.setTitle("Other", for: .normal)
    }
    
    func setIncomeButtonsTitles() {
        donationButton.setTitle("Salary", for: .normal)
        entertainmentButton.setTitle("Gift", for: .normal)
        healthButton.setTitle("Other", for: .normal)
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {

        if segmentedControl.selectedSegmentIndex == 0 {
            setExpenseButtonTitles()
            manageButtons(hidden: false)
            
        } else {
            setIncomeButtonsTitles()
            manageButtons(hidden: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        segmentedControl.selectedSegmentIndex = segmentedControlIndex
        
               if segmentedControlIndex == 0 {
                setExpenseButtonTitles()
             } else {
                 setIncomeButtonsTitles()
                 manageButtons(hidden: true)
             }
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let currentDate = datePicker.date
        if segmentedControlIndex == 0 {
                   
            print("expense is here")
            let new =  Transaction(id: UUID.init().uuidString, date: currentDate, category: pickedExpenseCategory?.rawValue ?? "", value: -numberTextField.finalValue, name: nameTextField?.text ?? "", icon: pickedExpenseCategory?.systemNameIcon ?? "")
            print(new)
            RealmManager.shared.addTransaction(new)
            
        } else {
            print("income is here")
            let new =  Transaction(id: UUID.init().uuidString, date: currentDate, category: pickerIncomeCategory?.rawValue ?? "", value: numberTextField.finalValue, name: nameTextField?.text ?? "", icon: pickerIncomeCategory?.systemNameIcon ?? "")
            print(new)
            RealmManager.shared.addTransaction(new)
        }
        performSegue(withIdentifier: "unwindToVC", sender: self)

    }

}

extension UITextField {
    var finalValue: Int { return Int(self.text ?? "") ?? 0 }
}






