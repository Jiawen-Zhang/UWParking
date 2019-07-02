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
import DropDown
import CoreData
import UserNotifications
import SCLAlertView


class MyMapViewController: UIViewController, CLLocationManagerDelegate{
    
    var FindMyLocation = [Double]()
    //var managedContext: NSManagedObjectContext!
    //var savedLocations = [NSManagedObject]()
    var savedLocations = [Location]()
    var MyCar = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    var MyCarFlag = false
    
    
    let LotLocations = LotLocation.getLots()
    
    let lotDropDown = DropDown()
    let carDropDown = DropDown()
    
    
    @IBOutlet weak var MyMapView: MKMapView!
    @IBOutlet weak var LotTypeDropDown: UIButton!
    @IBOutlet weak var MyCarDropDown: UIButton!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        MyMapView.delegate = self
        MyMapView.showsCompass = true
        
        MyMapView.register(LotView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        requestLocationAccess()
        loadSavedMyCarLocation()
        if(!savedLocations.isEmpty){
            /*let setMyCarAsLot = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: savedLocations.last!.latitude, longitude: savedLocations.last!.longitude))
            MyMapView.addAnnotation(setMyCarAsLot)*/
            let latitude = savedLocations.last!.latitude
            let longitude = savedLocations.last!.longitude
            MyCar.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            MyMapView.addAnnotation(MyCar)
            MyCarFlag = true
        }
        locationManager.startUpdatingLocation()
        loadInitView()
        addAnnotations(LotLocations, type: "Visitor")
        addPermitAnnotations(LotLocations)
        setupDropDown()
    }
    
    
    //**** Notifications after user pin his/her car ****
    func setNotification(_ timeInterval: Double){
        let content = UNMutableNotificationContent()
        let content_10 = UNMutableNotificationContent()
        content.title = "Remind Timer"
        content_10.title = "Remind Timer"
        content_10.body = "10 Minutes Remaining"
        //for test purpose set time as 10 secs
        //let alertTimeInterval = (timeInterval - 5) * 10
        var alertTimeInterval: Double
        if (timeInterval <= 5){
            alertTimeInterval = timeInterval * 60
            content.body = "Time Up"
        }
        else{
            alertTimeInterval = (timeInterval - 5) * 60
            content.body = "5 Minutes Remaining"
        }
        let alertTimeInterval_10 = (timeInterval - 10) * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alertTimeInterval, repeats: false)
        let trigger_10 = UNTimeIntervalNotificationTrigger(timeInterval: alertTimeInterval_10, repeats: false)
        let identifier = "Notification"
        let identifier_10 = "Notification_10"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request){ error in
            if (error == nil){
                print("Time Interval Notification scheduled: \(identifier)")
            }
        }
        let request_10 = UNNotificationRequest(identifier: identifier_10, content: content_10, trigger: trigger_10)
        UNUserNotificationCenter.current().add(request_10){ error in
            if (error == nil){
                print("Time Interval Notification scheduled: \(identifier_10)")
            }
        }
    }
    
    
    func setTimer(){
        let alert = SCLAlertView()
        let timefield = alert.addTextField("Parking Duration in Minutes")
        alert.addButton("Set"){
            let newTime: String? = timefield.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            let newTimeDouble = Double(newTime!)
            if(newTimeDouble != nil){
                self.setNotification(newTimeDouble!)
            }
        }
        alert.showEdit("Parking Duration", subTitle: "Please enter your parking duration in minutes", closeButtonTitle: "Cancel")
    }
    
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedContext.fetch(fetchRequest)
            savedLocations = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }*/
    
    /*func loadSavedMyCarLocation(){
        let entity = Location.entity()
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = entity
        savedLocations = try! managedObjectContext.fetch(fetchRequest)
    }
    
    func clearMyCar(){
        let location = savedLocations.last
        if let location = location {
            managedObjectContext.delete(location)
        }
        do {
            try managedObjectContext.save()
        } catch {
            //fatalCoreDataError(error)
            //Todo: need implement fatalCoreDataError
            print("Error")
        }
    }
    
    func MyCarCenterView() {
        if savedLocations.last != nil {
            let MyCarLocation = CLLocation(latitude: savedLocations.last!.latitude, longitude: savedLocations.last!.longitude)
            centerMapOnLocation(location: MyCarLocation)
        }
    }
    
    func showMyCar(){
        clearMyCar()
        MyCarCenterView()
    }*/
    
    /*func showMyCar(){
        /*let MyCarLocation = CarLocation()
        let location = CLLocation(latitude: MyCarLocation.latitude, longitude: MyCarLocation.longitude)
        centerMapOnLocation(location: location)*/
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedContext.fetch(fetchRequest)
            savedLocations = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func pinMyCar(){
        
    }
    
    func saveLocationtoPersistent(location: [Double]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)
        let currLocation = NSManagedObject(entity: entity!, insertInto: managedContext)
        currLocation.setValue(location[0], forKey: "latitude")
        currLocation.setValue(location[1], forKey: "longitude")
        do {
            try managedContext.save()
            savedLocations.append(currLocation)
        }
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }*/
    
    func saveLocationtoPersistent(location: [Double]){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        /*let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into: managedContext)*/
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)
        let currLocation = NSManagedObject(entity: entity!, insertInto: managedContext) as! Location
        currLocation.setValue(location[0], forKey: "latitude")
        currLocation.setValue(location[1], forKey: "longitude")
        do {
            try managedContext.save()
            //savedLocations.append(currLocation)
        }
        catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func showMyCar(){
        /*let MyCarLocation = CarLocation()
         let location = CLLocation(latitude: MyCarLocation.latitude, longitude: MyCarLocation.longitude)
         centerMapOnLocation(location: location)*/
        
        if(MyCarFlag){
            let MyCarLocation = CLLocation(latitude: MyCar.coordinate.latitude, longitude: MyCar.coordinate.longitude)
            centerMapOnLocation(location: MyCarLocation)
        }
        
        /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedContext.fetch(fetchRequest)
            savedLocations = results as! [Location]
            let MyCarLocation = CLLocation(latitude: savedLocations.last!.latitude, longitude: savedLocations.last!.longitude)
            /*let setMyCarAsLot = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: savedLocations.last!.latitude, longitude: savedLocations.last!.longitude))
            MyMapView.addAnnotation(setMyCarAsLot)*/
            centerMapOnLocation(location: MyCarLocation)
            //print(savedLocations)
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }*/
        
    }
    
    
    func pinMyCar(){
        
        if(!MyCarFlag){
            locationManager.startUpdatingLocation()
            if(!FindMyLocation.isEmpty){
                let latitude = FindMyLocation[0]
                let longitude = FindMyLocation[1]

                MyCar.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                MyMapView.addAnnotation(MyCar)
                
                let MyCarLocation = CLLocation(latitude: latitude, longitude: longitude)
                centerMapOnLocation(location: MyCarLocation)
                
                saveLocationtoPersistent(location: [latitude, longitude])
                
                MyCarFlag = true
                
                setTimer()
            }
            /*if(!savedLocations.isEmpty){
                
                //print("In Pin My Car")
                //print(savedLocations)
                
                let latitude = savedLocations.last!.latitude
                let longitude = savedLocations.last!.longitude
                
                //print("latitude: \(latitude)")
                //print("lonitude: \(longitude)")
                
                
                MyCar.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                MyMapView.addAnnotation(MyCar)
                
                let MyCarLocation = CLLocation(latitude: latitude, longitude: longitude)
                centerMapOnLocation(location: MyCarLocation)
                
                saveLocationtoPersistent(location: [latitude, longitude])
                
                MyCarFlag = true
                
            }*/
        }
        else{
            let MyCarLocation = CLLocation(latitude: MyCar.coordinate.latitude, longitude: MyCar.coordinate.longitude)
            centerMapOnLocation(location: MyCarLocation)
        }
       /*
        /*let MyCarLocation = CarLocation()
         let location = CLLocation(latitude: MyCarLocation.latitude, longitude: MyCarLocation.longitude)
         centerMapOnLocation(location: location)*/
        removeCar()
        locationManager.startUpdatingLocation()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let managedContext = appDelegate.persistentContainer.viewContext
        if(!savedLocations.isEmpty){
            let latitude = savedLocations.last!.latitude
            let longitude = savedLocations.last!.longitude
            
            /*let setMyCarAsLot = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            print(setMyCarAsLot.title)
            print(setMyCarAsLot.type)
            print(setMyCarAsLot.coordinate)
            
            MyMapView.addAnnotation(setMyCarAsLot)*/
            
            let MyCarLocation = CLLocation(latitude: latitude, longitude: longitude)
            centerMapOnLocation(location: MyCarLocation)
            
            saveLocationtoPersistent(location: [latitude, longitude])
        }*/
    
    }
    
    
    func clearMyCar(){
        
        if(MyCarFlag){
            
            MyMapView.removeAnnotation(MyCar)
            MyCar.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            do {
                let results = try managedContext.fetch(fetchRequest)
                /*savedLocations = results as! [Location]
                if(!savedLocations.isEmpty){
                    //print(savedLocations)
                    
                    /*for location in savedLocations{
                        managedContext.delete(location)
                    }*/
                }*/
                
                savedLocations = results as! [Location]
                if(!savedLocations.isEmpty){
                    //print(savedLocations)
                    
                    for location in savedLocations{
                        managedContext.delete(location)
                    }
                }
                
            } catch let error as NSError {
                print("Could not clear \(error), \(error.userInfo)")
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
            
            MyCarFlag = false
        }
     /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        /*for location in savedLocations{
            let setMyCarAsLot = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            MyMapView.removeAnnotation(setMyCarAsLot)
            managedContext.delete(location)
        }*/
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedContext.fetch(fetchRequest)
            savedLocations = results as! [Location]
            if(!savedLocations.isEmpty){
                for location in savedLocations{
                    /*let setMyCarAsLot = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    print(setMyCarAsLot.title)
                    print(setMyCarAsLot.type)
                    print(setMyCarAsLot.coordinate)*/
                    MyMapView.removeAnnotation(setMyCarAsLot)
                    managedContext.delete(location)
                }
            }
            /*if(!savedLocations.isEmpty){
                let MyCarLocation = CLLocation(latitude: savedLocations.last!.latitude, longitude: savedLocations.last!.longitude)
                centerMapOnLocation(location: MyCarLocation)
            }*/
        } catch let error as NSError {
            print("Could not clear \(error), \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }*/
    }
    
    
    func removeCar(){
        for location in savedLocations{
            let setMyCarAsLot = LotLocation(title: "My Car", subtitle: "", type: "MyCar", searchKey: "My Car", coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            MyMapView.removeAnnotation(setMyCarAsLot)
        }
    }
    
    func loadSavedMyCarLocation(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        do {
            let results = try managedContext.fetch(fetchRequest)
            savedLocations = results as! [Location]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    func setupDropDown(){
        lotDropDown.anchorView = LotTypeDropDown
        lotDropDown.dataSource = ["Test", "Visitor", "Meter", "Short-term", "Motorcycle"]
        lotDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
        carDropDown.anchorView = MyCarDropDown
        carDropDown.dataSource = ["My Car", "Pin My Car", "Clear Pin"]
        carDropDown.cellConfiguration = { (index, item) in return "\(item)" }
    }

    @IBAction func showLotTypeDropDown(_ sender: Any) {
        lotDropDown.show()
        lotDropDown.selectionAction = {
            (index: Int, item: String) in
            switch index{
            case 0: self.addAnnotations(self.LotLocations, type: "T")
            case 1: do {
                self.loadInitView()
                self.addAnnotations(self.LotLocations, type: "Visitor")
                self.addPermitAnnotations(self.LotLocations)
                }
            case 2: do {
                self.loadInitView()
                self.addAnnotations(self.LotLocations, type: "Meter")
                }
            case 3: do {
                self.loadInitView()
                self.addAnnotations(self.LotLocations, type: "Short-term")
                }
            case 4: do {
                self.loadInitView()
                self.addAnnotations(self.LotLocations, type: "Motorcycle")
                }
            default: ()
            }
        }
    }
    
    
    @IBAction func showMyCarDropDown(_ sender: Any) {
        carDropDown.show()
        carDropDown.selectionAction = {
            (index: Int, item: String) in
            switch index{
            case 0: self.showMyCar()
            case 1: self.pinMyCar()
            case 2: self.clearMyCar()
            default: ()
            }
        }
    }
    
    
    @IBAction func FindMe(_ sender: Any) {
        locationManager.startUpdatingLocation()
        if(!FindMyLocation.isEmpty){
            let initialLocation = CLLocation(latitude: FindMyLocation[0], longitude: FindMyLocation[1])
            centerMapOnLocation(location: initialLocation)
        }
    }
    
    
    //add an array of Annotation
    /*func addAnnotations(_ locations:[LotLocation]){
        for lot in locations{
            MyMapView.addAnnotation(lot)
        }
    }*/
    
    func addPermitAnnotations(_ locations: [LotLocation]){
        for lot in locations{
            if(lot.type == "C" || lot.type == "N" || lot.type == "W" || lot.type == "X"){
                MyMapView.addAnnotation(lot)
            }
        }
    }
    
    func addAnnotations(_ locations: [LotLocation], type: String){
        for lot in locations{
            if(lot.type != type){
                MyMapView.removeAnnotation(lot)
            }
            if(lot.type == type){
                MyMapView.addAnnotation(lot)
            }
        }
    }
    
    //location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1]
        let currLocation = locations.last!
        
        if currLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if(location.horizontalAccuracy > 0){
            let initialLocation = CLLocationCoordinate2D(latitude: currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude)
            JZLocationConverter.default.wgs84ToGcj02(initialLocation, result: {
                (Gcj02:CLLocationCoordinate2D) in
                self.FindMyLocation = self.formatter(Gcj02)
                //self.saveLocationtoPersistent(location: self.formatter(Gcj02))
                /*let currLocation = Location()
                let currLocation = NSManagedObject(entity: entity!, insertInto: managedContext) as! Location
                currLocation.latitude = self.formatter(Gcj02)[0]
                currLocation.longitude = self.formatter(Gcj02)[1]
                self.savedLocations.append(currLocation)*/
                
                /*let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)
                let currLocation = NSManagedObject(entity: entity!, insertInto: managedContext) as! Location
                currLocation.setValue(self.formatter(Gcj02)[0], forKey: "latitude")
                currLocation.setValue(self.formatter(Gcj02)[1], forKey: "longitude")
                self.savedLocations.append(currLocation)*/
                
                //self.saveLocationtoPersistent(location: self.formatter(Gcj02))
                
            })
            
            /*do{
                try managedObjectContext.save()
            }
            catch{
                //fatalCoreDataError(error)
                //Todo: need implement fatalErrorDataError
                print("Error in locationmanager")
            }*/
            
            //LonLatToCity()
            locationManager.stopUpdatingLocation()
        }
    }
    
    //request the user location
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
    
    //the init view of the map
    func loadInitView(){
        var CampusLocation_gcj02: CLLocation = CLLocation(latitude: 43.4722001169, longitude: -80.5461788177)
        let CampusLocation_wgs84 = CLLocationCoordinate2D(latitude: 43.4722001169, longitude: -80.5461788177)
        JZLocationConverter.default.wgs84ToGcj02(CampusLocation_wgs84, result: {
            (Gcj02:CLLocationCoordinate2D) in
            CampusLocation_gcj02 = CLLocation(latitude: self.formatter(Gcj02)[0], longitude: self.formatter(Gcj02)[1])
        })
        let regionRadius: CLLocationDistance = 3000
        let initCoordinateRegion = MKCoordinateRegion(center: CampusLocation_gcj02.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        MyMapView.setRegion(initCoordinateRegion, animated: true)
    }
    
    
}


extension MyMapViewController: MKMapViewDelegate{
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        guard let annotation = annotation as? LotLocation else {return nil}
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        //var view: MKAnnotationView
        
        if let dequeuedView = MyMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x:-5, y:5)
            let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapButton.setBackgroundImage(UIImage(named: "Direct"), for: UIControl.State())
            view.rightCalloutAccessoryView = mapButton
            //view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.markerTintColor = annotation.markerTintColor
        view.glyphText = String(annotation.type!.first!)
        return view
    }*/
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! LotLocation
        
        if(location.type == "MyCar"){
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        else{
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMaps(launchOptions: launchOptions)
        }
        
        /*let currentLocation: MKMapItem = MKMapItem.forCurrentLocation()
        let destCoordinate: CLLocationCoordinate2D = location.coordinate
        let destPlaceMark: MKPlacemark = MKPlacemark.init(coordinate: destCoordinate, addressDictionary: nil)
        let destLocation: MKMapItem = MKMapItem.init(placemark: destPlaceMark)
        destLocation.name = location.title
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey: "true"]
        MKMapItem.openMaps(with: [currentLocation, destLocation], launchOptions: launchOptions)*/
        
        
    }
    
}

