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
    let identifier = "cell"
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LotLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MyTableViewCell
        
        let lot = LotLocations[indexPath.row]
        cell?.ImageCell?.image = UIImage(named: (lot.type)!)
        cell?.LabelCell?.text = lot.title
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /*func loadFilterBar(){
        //add the filter bar
        let filter: FilterBar = FilterBar()
        filter.titles = ["Visitor", "Meter", "Motorcycle", "Short-term"]
        filter.barTintColor = UIColor.white
        filter.tintColor = UIColor.black
        filter.translucent = true
        self.view.addSubview(filter)
        
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: filter, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 8.0)
        self.view.addConstraint(topConstraint)
        filter.addTarget(self, action: "segmentChanged:", for: .valueChanged)
        
    }*/
    
    
    //implement fold
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** Importent ****
        //need to register the xib otherwise
        //it shows nothing
        let nib = UINib.init(nibName: "MyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        let tableView = UITableView.init(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}
