//
//  MapViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 04/11/20.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var imageName: String = ""
    var exName:String = ""
    var exDes: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var imageIcon: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let latitude:CLLocationDegrees = -37.8304
        let longitude:CLLocationDegrees = 144.9796
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let zoomRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
        _ = UIApplication.shared.delegate as! AppDelegate
        
    }
    

    //zoom in on the map
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }

}
