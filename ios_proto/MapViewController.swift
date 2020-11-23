//
//  MapViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 04/11/20.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, DatabaseListener {
    
    //refernces
    //annotations: https://stackoverflow.com/questions/42351358/swift-custom-mkpointannotation-with-image
    
    //References:
    //call out: https://stackoverflow.com/questions/51091590/swift-storyboard-creating-a-segue-in-mapview-using-calloutaccessorycontroltapp

    //How to pass map annotation on segue to mapView on another vc?:  https://stackoverflow.com/questions/44139763/how-to-pass-map-annotation-on-segue-to-mapview-on-another-vc

    //Perform Segue from map annotation:  https://stackoverflow.com/questions/33053832/swift-perform-segue-from-map-annotation
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
    var eventsList = [LocationAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        //centers map
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
    
    lazy var removeAnno: Void = {
        print(eventsList.count)
        print("number")
        mapView.removeAnnotations(eventsList)
    }()
    
    // MARK: - Database Listener
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        allEvents = events
        print (allEvents.count)
        for event in allEvents {
            let location = LocationAnnotation(title: event.eventName ?? "", subtitle: event.sport ?? "", image: event.annotationImg ?? "", lat: event.lat ?? 0.0 , long: event.long ?? 0.0)
            eventsList.append(location)
        }
        
        for i in eventsList{
            mapView.addAnnotation(i)
        }
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
        //do nothing
    }
    
    func onUserListChange(change: DatabaseChange, users: [Users]) {
        //do nothing
    }
    
    //zoom in on the map
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    //adds annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {  //Handle user location annotation..
            return nil  //Default is to let the system handle it.
        }
        
        if !annotation.isKind(of: ImageAnnotation.self) {  //Handle non-ImageAnnotations..
            var pinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "DefaultPinView")
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "DefaultPinView")
                pinAnnotationView?.canShowCallout = true
                pinAnnotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return pinAnnotationView
        }
        
        //Handle ImageAnnotations..
        var view: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: "imageAnnotation") as? ImageAnnotationView
        if view == nil {
            view = ImageAnnotationView(annotation: annotation, reuseIdentifier: "imageAnnotation")
        }
        
        let annotation = annotation as! ImageAnnotation
        view?.image = annotation.image
        view?.annotation = annotation
        
        return view
    }
    
    var loco : MKPointAnnotation!
    
    //send data to exhibition details view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EventsDetailsViewController
        {
            let ed = segue.destination as? EventsDetailsViewController
            ed?.name = exName
            ed?.sportType = exDes
            ed?.lat = lat
            ed?.long = long
            ed?.icon = imageIcon
            ed?.pin = loco
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            
            for event in allEvents{
                if exName == event.eventName {
                    ed?.dateTime = dateFormatter.string(from: event.eventDateTime!)
                    ed?.noOfPlayers = String(event.numberOfPlayers!)
                    ed?.minNoOfPlayers = String(event.minNumPlayers!)
                    ed?.location = event.locationName!
                    ed?.icon = event.annotationImg!
                }
            }
        }
    }
    
    //annotation call out to move to the next view
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            loco = view.annotation as? MKPointAnnotation
            exName = view.annotation!.title!!
            exDes = view.annotation!.subtitle!!
            lat = view.annotation!.coordinate.latitude
            long = view.annotation!.coordinate.longitude
            
            performSegue(withIdentifier: "mapEventsSegue", sender: self)
        }
    }
    
    class ImageAnnotation : NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        var image: UIImage?
        var colour: UIColor?
        
        override init() {
            self.coordinate = CLLocationCoordinate2D()
            self.title = nil
            self.subtitle = nil
            self.image = nil
            self.colour = UIColor.white
        }
    }
    
    class ImageAnnotationView: MKAnnotationView {
        private var imageView: UIImageView!
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            self.addSubview(self.imageView)
            
            self.imageView.layer.cornerRadius = 5.0
            self.imageView.layer.masksToBounds = true
        }
        
        override var image: UIImage? {
            get {
                return self.imageView.image
            }
            
            set {
                self.imageView.image = newValue
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    
}
