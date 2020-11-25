//
//  ChangesUpdate.swift
//  finance
//
//  Created by mac on 23/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import Foundation

enum ChangesUpdate {
    case initial
    case update(deletions: [Int], insertions: [Int], modifications: [Int])
    case error(_: Error)
}
