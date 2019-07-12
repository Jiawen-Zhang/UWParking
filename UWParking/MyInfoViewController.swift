//
//  MyInfoViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-07-01.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class MyInfoViewController: UIViewController{
    
    @IBOutlet weak var Phone: UIButton!
    
    @IBAction func PhoneTapped(_ sender: Any) {
        let url:URL?=URL.init(string: "tel:519-888-4567,,,33100")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    
    @IBOutlet weak var Email: UIButton!
    
    @IBAction func EmailTapped(_ sender: Any) {
        let url:URL?=URL.init(string: "mailto:uparking@uwaterloo.ca")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var Navi: UIButton!
    
    @IBAction func NaviTapped(_ sender: Any) {
        let latitude = 43.4734361326
        let longitude = -80.5425853282
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem(placemark:MKPlacemark(coordinate:location,addressDictionary:nil))
        toLocation.name = "UW Parking Services"
        MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    
    @IBOutlet weak var Homepage: UIButton!
    
    @IBOutlet weak var Facebook: UIButton!
    
    @IBOutlet weak var Twitter: UIButton!
    
    @IBAction func HomepageTapped(_ sender: Any) {
        let url:URL?=URL.init(string: "https://uwaterloo.ca/parking")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func FacebookTapped(_ sender: Any) {
        let url:URL?=URL.init(string: "https://www.facebook.com/pages/category/College---University/UWaterloo-Parking-640026479342393/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func TwitterTapped(_ sender: Any) {
        let url:URL?=URL.init(string: "https://mobile.twitter.com/uwparking?ref_url=https%3a%2f%2fuwaterloo.ca%2fparking%2fhome/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
