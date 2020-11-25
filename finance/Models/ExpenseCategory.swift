//
//  Category.swift
//  finance
//
//  Created by mac on 08/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import Foundation
import UIKit

enum ExpenseCategory: String, CaseIterable {
    
    case donation
    case food
    case entertainment
    case health
    case shopping
    case transportation
    case utilities
    case otherExpense
    
    var systemNameIcon: String {
        switch self {
        case .donation: return "1"
        case .food: return "2"
        case .entertainment: return "3"
        case .health: return "4"
        case .shopping: return "5"
        case .transportation: return "6"
        case .utilities: return "7"
        case .otherExpense: return "8"
            
       
        }
    }
    
    var color: UIColor {
        switch self {
        case .donation: return UIColor.red
        case .food: return UIColor.blue
        case .entertainment: return UIColor.brown
        case .health: return UIColor.gray
        case .shopping: return UIColor.yellow
        case .transportation: return UIColor.green
        case .utilities: return UIColor.blue
        case .otherExpense: return UIColor.purple
        }
    }
}

extension ExpenseCategory: Identifiable {
    var id: String { rawValue }
}


