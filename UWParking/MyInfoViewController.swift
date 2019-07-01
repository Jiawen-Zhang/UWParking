//
//  MyInfoViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-07-01.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
import UIKit


class MyInfoViewController: UIViewController{
    
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
