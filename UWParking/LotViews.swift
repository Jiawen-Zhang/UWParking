//
//  LotViews.swift
//  UWParking
//
//  Created by Jack Zhang on 2019-06-13.
//  Copyright © 2019 Jack Zhang. All rights reserved.
//

import Foundation
import MapKit

class LotMarkerView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let lot = newValue as? LotLocation else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = lot.markerTintColor
            if let imageName = lot.imageName{
                glyphImage = UIImage(named: imageName)
            }
            else{
                glyphImage = nil
            }
        }
    }
}

class LotView: MKAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let lot = newValue as? LotLocation else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let mapButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            mapButton.setBackgroundImage(UIImage(named: "Direct"), for: UIControl.State())
            rightCalloutAccessoryView = mapButton
            
            if let imageName = lot.imageName{
                image = UIImage(named: imageName)
            }
            else{
                image = nil
            }
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = lot.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}

