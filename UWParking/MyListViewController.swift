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
        cell?.LabelCell?.text = lot.title
        
        return cell!
    }
    
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
