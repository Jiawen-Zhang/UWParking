//
//  LotLocation.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-12.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import MapKit
import JZLocationConverterSwift
import Contacts

@objc class LotLocation: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var type: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, type: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.coordinate = coordinate
    }
    
    static func getLots() -> [LotLocation] {
        guard let path = Bundle.main.path(forResource: "LotLocation", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        
        var LotLocations = [LotLocation]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            let title = dictionary?["title"] as? String
            let subtitle = dictionary?["description"] as? String
            let type = dictionary?["lotType"] as? String
            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = dictionary?["longitude"] as? Double ?? 0
            let location = LotLocation(title: title, subtitle: subtitle, type: type, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            LotLocations.append(location)
        }
        
        return LotLocations as [LotLocation]
    }
    
    var markerTintColor: UIColor{
        switch type{
        case "C":
            return .red
        case "N":
            return .cyan
        case "W":
            return .blue
        case "X":
            return .purple
        default:
            return .green
        }
    }
    
    var imageName: String?{
        switch type{
        case "C":
            return "C"
        case "N":
            return "N"
        case "W":
            return "W"
        case "X":
            return "X"
        default:
            return nil
        }
    }
    
    func mapItem() -> MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
       /*
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title*/
        
        return mapItem
    }
    
}
