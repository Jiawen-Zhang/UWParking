//
//  LotCell.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-17.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit

class LotCell: UITableViewCell {
    
    class func cellWithTableView(tableView: UITableView) -> LotCell{
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = LotCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        }
        return cell as! LotCell
    }
    
    var CellData: ParkingCell?{
        didSet{
            self.imageView?.image = UIImage(named: CellData!.icon!)
            self.textLabel?.text = CellData!.name!
            self.detailTextLabel?.text = CellData!.info!
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
