//
//  MyListViewController.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-05.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import UIKit

class MyListViewController: UITableViewController, UISearchResultsUpdating{
    
    let LotLocations = LotLocation.getLots()
    let identifier = "cell"
    var LotDict = [String: [LotLocation]]()
    var SectionTitles = [String]()
    
    var SearchController: UISearchController!
    var searchResults = [LotLocation]()
    
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
        SectionTitles = ["T", "C", "N", "W", "X", "Visitor", "Meter", "Short-term", "Motorcycle"]
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
        
        /*let lot = LotLocations[indexPath.row]
        cell?.ImageCell?.image = UIImage(named: (lot.type)!)
        cell?.LabelCell?.text = lot.title*/
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let LotKey = SectionTitles[indexPath.section]
        let LotValues = LotDict[LotKey]
        let lot = SearchController.isActive ? searchResults[indexPath.row] : LotValues![indexPath.row]
        let map = UITableViewRowAction(style: .normal, title: "Map"){
            action, index in
            //print(lot.title)
            /*let secondViewController = MyMapViewController()
            self.present(secondViewController, animated: true, completion: nil)*/
        }
        return [map]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !SearchController.isActive
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
        
        //define the search controller
        SearchController = UISearchController(searchResultsController: nil)
        SearchController.searchResultsUpdater = self
        tableView.tableHeaderView = SearchController.searchBar
        SearchController.dimsBackgroundDuringPresentation = false
        SearchController.searchBar.placeholder = "Find the nearest parking to your dest."
        /*if let textfield = SearchController.searchBar.subviews.first?.subviews.last as? UITextField{
            textfield.attributedText = NSAttributedString(string: "Find the nearest parking to your destination?", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize:15)])
        }*/
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


