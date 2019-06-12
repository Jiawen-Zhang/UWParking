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
import JZLocationConverterSwift


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
        loadInitView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1]
        let currLocation = locations.last!
        if(location.horizontalAccuracy > 0){
            let initialLocation = CLLocationCoordinate2D(latitude: currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude)
            JZLocationConverter.default.wgs84ToGcj02(initialLocation, result: {
                (Gcj02:CLLocationCoordinate2D) in
                //centerMapOnLocation(location: self.formatter(Gcj02))
                self.FindMyLocation = self.formatter(Gcj02)
            })
            //FindMyLocation.append(lat!)
            //FindMyLocation.append(long!)
            //FindMyLocation[0] = lat!
            //FindMyLocation[1] = long!
            //print("Latitude:\(lat!)")
            //print("Longitude:\(long!)")
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
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MyMapView.setRegion(coordinateRegion, animated: true)
    }
    
    //formatter for CLLocationCoordinate2D -> Double Array
    func formatter(_ p:CLLocationCoordinate2D) -> [Double] {
        let temp_lat = Double(String(format: "%.14f", p.latitude))
        let temp_long = Double(String(format: "%.14f", p.longitude))
        let temp:[Double] = [temp_lat!, temp_long!]
        return temp
    }
    
    func loadInitView(){
        var CampusLocation_gcj02: CLLocation = CLLocation(latitude: 43.4722624, longitude: -80.5447643)
        let CampusLocation_wgs84 = CLLocationCoordinate2D(latitude: 43.4722624, longitude: -80.5447643)
        JZLocationConverter.default.wgs84ToGcj02(CampusLocation_wgs84, result: {
            (Gcj02:CLLocationCoordinate2D) in
            CampusLocation_gcj02 = CLLocation(latitude: self.formatter(Gcj02)[0], longitude: self.formatter(Gcj02)[1])
        })
        let regionRadius: CLLocationDistance = 3000
        let initCoordinateRegion = MKCoordinateRegion(center: CampusLocation_gcj02.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MyMapView.setRegion(initCoordinateRegion, animated: true)
    }
    
}
