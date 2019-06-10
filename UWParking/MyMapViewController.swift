//
//  MyMapViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-10.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MyMapViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var MyMapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        requestLocationAccess()
        
    }
    
    func requestLocationAccess(){
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            manager.requestWhenInUseAuthorization()
        }
        manager.startUpdatingLocation()
        MyMapView.showsUserLocation = true
    }
}
