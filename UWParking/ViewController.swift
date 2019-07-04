//
//  ViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-03.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit
import WatSwift

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        WatSwift.apiKey = "532bfebea989a4a5bc40da4fc7d6b1d4";
        
        WatSwift.FoodServices.menu{ response in
            if let outletName = response.data["outlets"][0]["outlet_name"].string{
                print(outletName)
            }
        }
    }

}

