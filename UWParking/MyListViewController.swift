//
//  MyListViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit
import MapKit
import SCLAlertView

class MyListViewController: UITableViewController, UISearchResultsUpdating{
    
    let LotLocations = LotLocation.getLots()
    let identifier = "cell"
    var LotDict = [String: [LotLocation]]()
    var SectionTitles = [String]()
    
    var SearchController: UISearchController!
    var searchResults = [LotLocation]()
    
    var selectIndex: IndexPath?
    
    
    
    func createLotDict(){

        for lot in LotLocations{
            let LotKey = lot.type
            
            if var LotValues = LotDict[LotKey!]{
                LotValues.append(lot)
                LotDict[LotKey!] = LotValues
            }
            else{
                LotDict[LotKey!] = [lot]
            }
        }
        //SectionTitles = [String](LotDict.keys)
        SectionTitles = ["C", "N", "W", "X", "Visitor", "Meter", "Short-term", "Motorcycle"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SearchController.isActive ? 1 : SectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SearchController.isActive ? "Result" : SectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let LotKey = SectionTitles[section]
        guard let LotValues = LotDict[LotKey] else {return 0}
        return SearchController.isActive ? searchResults.count : LotValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MyTableViewCell
        
        let LotKey = SectionTitles[indexPath.section]
        if let LotValues = LotDict[LotKey]{
            let lot = SearchController.isActive ? searchResults[indexPath.row] : LotValues[indexPath.row]
            cell?.ImageCell?.image = UIImage(named: (lot.type)!)
            cell?.LabelCell?.text = lot.title
        }
        
        if(selectIndex == indexPath){
            cell?.accessoryType = .checkmark
        }
        else{
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(selectIndex == nil){
            selectIndex = indexPath
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
        }
        else{
            let called = tableView.cellForRow(at: selectIndex!)
            called?.accessoryType = .none
            selectIndex = indexPath
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
        }
        
        let LotKey = SectionTitles[indexPath.section]
        if let LotValues = LotDict[LotKey]{
            let lot = SearchController.isActive ? searchResults[indexPath.row] : LotValues[indexPath.row]
            
            let alert = SCLAlertView()
            alert.showEdit(lot.title!, subTitle: lot.subtitle!, closeButtonTitle: "Cancel", colorStyle:0xd4237a, circleIconImage: UIImage(named: "ListAlertIcon"))
            
        }
        
        
    }
    
    
    //**** swipe left for navigation ****
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let LotKey = SectionTitles[indexPath.section]
        let LotValues = LotDict[LotKey]
        let lot = SearchController.isActive ? searchResults[indexPath.row] : LotValues![indexPath.row]
        let map = UITableViewRowAction(style: .normal, title: "Navigation"){
            action, index in
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            lot.mapItem().openInMaps(launchOptions: launchOptions)
        }
        return [map]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //return !SearchController.isActive
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    //Set the Search
    func updateSearchResults(for SearchController: UISearchController){
        if var text = SearchController.searchBar.text{
            text = text.trimmingCharacters(in: .whitespaces)
            searchFilter(text: text)
            tableView.reloadData()
        }
    }
    
    func searchFilter(text: String){
        searchResults = LotLocations.filter({(lot) -> Bool in
            return lot.searchKey!.localizedCaseInsensitiveContains(text)
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //define the search controller
        SearchController = UISearchController(searchResultsController: nil)
        SearchController.searchResultsUpdater = self
        tableView.tableHeaderView = SearchController.searchBar
        SearchController.dimsBackgroundDuringPresentation = false
        SearchController.searchBar.placeholder = "Find the nearest parking to your dest."
        //SearchController.searchBar.searchBarStyle = .minimal
        SearchController.searchBar.searchBarStyle = .default
        
        //**** Importent ****
        //need to register the xib otherwise
        //it shows nothing
        let nib = UINib.init(nibName: "MyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        let tableView = UITableView.init(frame: view.frame, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        createLotDict()
    }
}


