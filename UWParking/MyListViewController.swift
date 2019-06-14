//
//  MyListViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit

class MyListViewController: UITableViewController{
    
    let LotLocations = LotLocation.getLots()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LotLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = LotLocations[indexPath.row].title
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*tableView = UITableView.init(frame: self.view.frame, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)*/
        
        let tableView = UITableView.init(frame: view.frame, style: .plain)
        //let tableView = UITableView(frame: view.bounds, style: .grouped)
        //view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        //let path = Bundle.main.path(forResource: "LotLocation", ofType: "plist")
        //self.cells = NSDictionary(contentsOfFile: path!)
        
        
        /*let path = Bundle.main.bundlePath
        let plistName: NSString = "LotLocation.plist"
        let finalPath: NSString = (path as NSString).appendingPathComponent(plistName as String) as NSString
        cells = NSDictionary(contentsOfFile: finalPath as String)*/
        
        
        
    }
    
    
}
