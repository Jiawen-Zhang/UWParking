//
//  MyHomeViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit
import WatSwift

class result{
    var lot_name = ""
    var latitude = 0.0
    var longitude = 0.0
    var capacity = 0
    var current_count = 0
    var percent_filled = 0
    var last_updated = ""
}

class MyHomeViewController: UIViewController{
    //private let DataResult = UpdateCurrentCapability();
    
    @IBOutlet weak var LotC: UILabel!
    
    //let Lot_C = result()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        WatSwift.Parking.watpark{ response in
            let data: JSON = response.data
            /*if let loc_c = data[0]["lot_name"].string{
             print(lot_name_1)
             }*/
            /*if let lot_C_name = data[0]["lot_name"].string{
                //set Lot_C name
                self.Lot_C.lot_name = lot_C_name
            }*/
            if let lot_C_name = data[0]["lot_name"].string{
                print(lot_C_name)
            }
        }
        
        //self.LotC.text = Lot_C.lot_name
    }
}


