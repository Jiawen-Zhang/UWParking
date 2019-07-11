//
//  MyHomeViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit
import WatSwift


class MyHomeViewController: UIViewController{
    
    
    @IBOutlet weak var NumC: UILabel!
    @IBOutlet weak var NumN: UILabel!
    @IBOutlet weak var NumW: UILabel!
    @IBOutlet weak var NumX: UILabel!
    
    @IBAction func RefreshButton(_ sender: Any) {
        print("Refreshing")
        self.NumC.text = ""
        self.NumN.text = ""
        self.NumW.text = ""
        self.NumX.text = ""
        //delay 0.1 second to let user know I am refreshing
        let time: TimeInterval = 0.1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time){
            self.loadParkingData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load the Parking Lot status
        loadParkingData()
    }
    
    
    
    private func loadParkingData(){
        WatSwift.apiKey = "532bfebea989a4a5bc40da4fc7d6b1d4"
        
        WatSwift.Parking.watpark{ response in
            let data: JSON = response.data
            //get the parking lot C data from UW Open Data API
            var AvailableC = 0
            if let lot_C_capacity = data[0]["capacity"].integer{
                AvailableC += lot_C_capacity
            }
            if let lot_C_current = data[0]["current_count"].integer{
                AvailableC -= lot_C_current
            }
            
            //get the parking lot N data from UW Open Data API
            var AvailableN = 0
            if let lot_N_capacity = data[1]["capacity"].integer{
                AvailableN += lot_N_capacity
            }
            if let lot_N_current = data[1]["current_count"].integer{
                AvailableN -= lot_N_current
            }
            
            //get the parking lot W data from UW Open Data API
            var AvailableW = 0
            if let lot_W_capacity = data[2]["capacity"].integer{
                AvailableW += lot_W_capacity
            }
            if let lot_W_current = data[2]["current_count"].integer{
                AvailableW -= lot_W_current
            }
            
            //get the parking lot X data from UW Open Data API
            var AvailableX = 0
            if let lot_X_capacity = data[3]["capacity"].integer{
                AvailableX += lot_X_capacity
            }
            if let lot_X_current = data[3]["current_count"].integer{
                AvailableX -= lot_X_current
            }
            
            //update the data on HomeView
            self.NumC.text = String(AvailableC)
            self.NumN.text = String(AvailableN)
            self.NumW.text = String(AvailableW)
            self.NumX.text = String(AvailableX)
        }
    }
    
}


