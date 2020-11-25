//
//  LogTableViewCell.swift
//  finance
//
//  Created by mac on 16/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }


}
