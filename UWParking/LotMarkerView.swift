//
//  LotMarkerView.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-12.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
import MapKit

class LotMarkerView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let location = newValue as? LotLocation else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = location.markerTintColor
            glyphText = String(location.type!.first!)
        }
    }
}
