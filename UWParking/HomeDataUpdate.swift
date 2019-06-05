//
//  HomeDataUpdate.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
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

class UpdateCurrentCapability{
    WatSwift.apiKey = "532bfebea989a4a5bc40da4fc7d6b1d4"
    
    WatSwift.Parking.watpark{ response in
    let data: JSON = response.data
    /*if let loc_c = data[0]["lot_name"].string{
    print(lot_name_1)
    }*/
    //let Lot_C = result()
    //Lot_c.lot_name = data[0]["lot_name"].string
    
    
    }
}


