//
//  MapViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 04/11/20.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, DatabaseListener {

    @IBOutlet weak var mapView: MKMapView!
    
    
    var imageName: String = ""
    var exName:String = ""
    var exDes: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var imageIcon: String = ""
    var listenerType: ListenerType = .all
    weak var databaseController: DatabaseProtocol?
    var allEvents: [Events] = []
    //var fliteredEvents: based on swiped sports
    var eventsList = [LocationAnnotation]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let latitude:CLLocationDegrees = -37.8304
        let longitude:CLLocationDegrees = 144.9796
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let zoomRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //adds annotations to the map view first
    private lazy var addAnno: Void = {
        for event in allEvents {
            let location = LocationAnnotation(title: event.eventName ?? "", subtitle: event.locationName ?? "", image: event.annotationImg ?? "", lat: event.lat ?? 0.0 , long: event.long ?? 0.0)
            eventsList.append(location)
        }
        
        for i in eventsList{
            mapView.addAnnotation(i)
        }
    }()
    
    lazy var removeAnno: Void = {
        print(eventsList.count)
        print("number")
        mapView.removeAnnotations(eventsList)
    }()
    
    // MARK: - Database Listener
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        allEvents = events
        print (allEvents.count)
        _ = addAnno
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
        //do nothing
    }
    

    //zoom in on the map
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    //too add annotation images
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        annotationView?.image = nil
        exName = ""
        exDes = ""
        lat = 0.0
        long = 0.0
        
        let cpa = annotation as! LocationAnnotation
        annotationView?.image = UIImage(named: cpa.image ?? "")
        annotationView?.canShowCallout = true
        annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return annotationView
    }
    
    var loco : MKPointAnnotation!
    
    //send data to exhibition details view
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.destination is ExhibitionDetailsViewController
//        {
//            let ed = segue.destination as? ExhibitionDetailsViewController
//            ed?.name = exName
//            ed?.des = exDes
//            ed?.lat = lat
//            ed?.long = long
//            ed?.icon = imageIcon
//            ed?.pin = loco
//        }
//    }
    
    //annotation call out to move to the next view
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            loco = view.annotation as? MKPointAnnotation
//            exName = view.annotation!.title!!
//            exDes = view.annotation!.subtitle!!
//            lat = view.annotation!.coordinate.latitude
//            long = view.annotation!.coordinate.longitude
//
//            performSegue(withIdentifier: "exhibitionDetailsSegue", sender: self)
//        }
//    }

}
