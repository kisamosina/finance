//
//  RealmManager.swift
//  finance
//
//  Created by mac on 03/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    let realm =  try! Realm()
    
    var transactions: Results<TransactionRealm>
    private var notificationToken: NotificationToken?
//    var transactionsByMonth: Results<TransactionRealm>
    

    
//    let trainingsBetweenDates = realm.objects(Trainings.self).filter("date BETWEEN {%@, %@}", startDate, endDate)
    
    
    
    
    init() {
//        let todayStart = Calendar.current.startOfDay(for: Date())
//
//        let todayEnd: Date = {
//          let components = DateComponents(day: 1, second: -1)
//            return Calendar.current.date(byAdding: components, to: todayStart)!
//        }()
//
        transactions = realm.objects(TransactionRealm.self).sorted(byKeyPath: "date", ascending: false)
//        transactionsByMonth = realm.objects(TransactionRealm.self).filter("date BETWEEN %@", [todayStart, todayEnd])
    }
   
    
    func addTransaction(_ transaction: Transaction) {
        
        var newTransactions = [TransactionRealm]()
        
        let newTransaction = TransactionRealm()
        
        newTransaction.id = transaction.id
        newTransaction.date = transaction.date
        newTransaction.category = transaction.category
        newTransaction.value = transaction.value
        newTransaction.name = transaction.name
        newTransaction.icon = transaction.icon
        
        newTransactions.append(newTransaction)
        
        try! self.realm.write {
            realm.add(newTransactions)
        }
        
    }
    
    func deleteTransaction(at index: Int) {
        try! self.realm.write {
            realm.delete(transactions[index])

        }
    }
    
    func priceSum(_ transactions: Results<TransactionRealm>) -> Int {
        let sum = transactions.reduce (0, { result, transaction in
        result + transaction.value
            
        })

        return sum
    }
    
    func beginUpdate (_ label: UILabel) {
        notificationToken = transactions.observe {[weak self] change in
            guard let weakself = self else { return }
            
            let batchUpdate: ChangesUpdate
            
            switch change {
            case .initial:
                
                batchUpdate = .initial
                
            case .update(_, let deletions, let insertions, let modifications):
                
                batchUpdate = .update(
                    deletions: deletions,
                    insertions: insertions,
                    modifications: modifications)
                print("update")
                print(batchUpdate)
                
            case .error(let error):
                
                batchUpdate = .error(error)
                
                
            }
            label.text! = "Balance: " + String(self!.priceSum(self!.transactions)) + "$"
            
        }
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}

//extension Results {
//   func toArray() -> [Element] {
//     return compactMap {
//       $0
//     }
//   }
//}
