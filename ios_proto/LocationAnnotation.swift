//
//  LocationAnnotation.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    //to help annotate the map view
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: String?
    
    init(title: String, subtitle: String,image: String, lat: Double, long: Double) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

}
