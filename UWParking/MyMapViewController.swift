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
    
    var FindMyLocation = [Double]()
    
    @IBOutlet weak var MyMapView: MKMapView!
    
    @IBAction func FindMe(_ sender: Any) {
        locationManager.startUpdatingLocation()
        if(!FindMyLocation.isEmpty){
            let initialLocation = CLLocation(latitude: FindMyLocation[0], longitude: FindMyLocation[1])
            centerMapOnLocation(location: initialLocation)
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        requestLocationAccess()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1]
        let currLocation = locations.last!
        if(location.horizontalAccuracy > 0){
            let lat = Double(String(format: "%.15f", currLocation.coordinate.latitude))
            let long = Double(String(format: "%.15f", currLocation.coordinate.longitude))
            if(!FindMyLocation.isEmpty){
                FindMyLocation.removeAll()
            }
            FindMyLocation.append(lat!)
            FindMyLocation.append(long!)
            //FindMyLocation[0] = lat!
            //FindMyLocation[1] = long!
            print(FindMyLocation[0])
            print(FindMyLocation[1])
            print("Latitude:\(lat!)")
            print("Longitude:\(long!)")
            locationManager.stopUpdatingLocation()
            //LonLatToCity()
            //locationManager.stopUpdatingLocation()
        }
    }
    
    
    
    func requestLocationAccess(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let status = CLLocationManager.authorizationStatus()
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        MyMapView.showsUserLocation = true
    }
    
    func centerMapOnLocation(location: CLLocation){
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MyMapView.setRegion(coordinateRegion, animated: true)
    }
}
