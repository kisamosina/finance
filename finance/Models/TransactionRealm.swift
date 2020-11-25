//
//  Model.swift
//  finance
//
//  Created by mac on 02/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import Foundation
import RealmSwift

class TransactionRealm: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date: Date!
    @objc dynamic var category = ""
    @objc dynamic var name = ""
    @objc dynamic var value = 0
    @objc dynamic var icon = ""
    
    override static func primaryKey() -> String? {
      return "id"
    }
    
}


