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
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var current: UILabel!
    
    @IBOutlet weak var LotName: UILabel!
    @IBOutlet weak var LotC_capacity: UILabel!
    @IBOutlet weak var LotC_current: UILabel!
    //let Lot_C = result()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        WatSwift.apiKey = "532bfebea989a4a5bc40da4fc7d6b1d4"
        
        WatSwift.Parking.watpark{ response in
            let metadata = response.metadata
            let data: JSON = response.data
            print(metadata)
            print(data)
            /*if let loc_c = data[0]["lot_name"].string{
             print(lot_name_1)
             }*/
            /*if let lot_C_name = data[0]["lot_name"].string{
                //set Lot_C name
                self.Lot_C.lot_name = lot_C_name
            }*/
            if let lot_C_name = data[3]["lot_name"].string{
                print(lot_C_name)
                self.LotName.text=lot_C_name
            }
            if let lot_C_capacity = data[3]["capacity"].integer{
                print(lot_C_capacity)
                self.LotC_capacity.text = String(lot_C_capacity)
            }
            if let lot_C_current = data[3]["current_count"].integer{
                print(lot_C_current)
                self.LotC_current.text = String(lot_C_current)
            }
        }
    }
}


