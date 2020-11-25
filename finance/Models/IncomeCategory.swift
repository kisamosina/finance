//
//  IncomeCategory.swift
//  finance
//
//  Created by mac on 08/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import Foundation
import UIKit

enum IncomeCategory: String, CaseIterable {
    
    case salary
    case gift
    case otherIncome
    
    var systemNameIcon: String {
        switch self {
        case .salary: return "1.1"
        case .gift: return "1.2"
        case .otherIncome: return "1.3"

        }
    }
    
    var color: UIColor {
        switch self {
        case .salary: return UIColor.red
        case .gift: return UIColor.yellow
        case .otherIncome: return UIColor.purple
        
        }
    }
}

extension IncomeCategory: Identifiable {
    var id: String { rawValue }
}

