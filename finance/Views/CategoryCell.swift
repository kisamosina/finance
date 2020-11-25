//
//  CategoryTableViewCell.swift
//  finance
//
//  Created by mac on 20/11/2020.
//  Copyright © 2020 kisamosina. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var pictureImage: UIImageView!
       @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var dateLabel: UILabel!
       
       @IBOutlet weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
