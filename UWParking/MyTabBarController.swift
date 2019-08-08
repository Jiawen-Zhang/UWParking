//
//  MyTabBarController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
//import WatSwift


class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //change the tab bar item selected tint
        let pink = UIColor("#d4237a")
        //self.tabBar.tintColor = UIColor.purple
        self.tabBar.tintColor = pink
        
    }
    
}
