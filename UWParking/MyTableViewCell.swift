//
//  MyTableViewCell.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-14.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageCell: UIImageView!
    
    @IBOutlet weak var LabelCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

