//
//  ParkingCellHeader.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-17.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation

class ParkingCellHeader: NSObject{
    var name: String?
    var Lots: NSArray?
    var isOpen: Bool? = false
    
    /*init(withDic dic: NSDictionary){
        super.init()
        self.setValuesForKeys(dic as! [String : Any])
        let ParkingLots = NSMutableArray()
        for LotDic in self.Lots!{
            let lot:ParkingCell = ParkingCell.init(dic: LotDic as! NSDictionary)
            ParkingLots.add(lot)
        }
        self.Lots = ParkingLots
    }*/
}
