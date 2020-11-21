//
//  CreateEventViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 21/11/20.
//

import UIKit
import MapKit

class CreateEventViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var maxNumPlayersTextField: UITextField!
    @IBOutlet weak var minNumPlayersTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDateTimeTextField: UITextField!
    
    var lat = 0.0
    var long = 0.0
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var listenerType: ListenerType = .all
    
    private var datePicker: UIDatePicker?
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        eventDateTimeTextField.inputView = datePicker
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        mapView.delegate = self
        
        let latitude:CLLocationDegrees = -37.8304
        let longitude:CLLocationDegrees = 144.9796
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let zoomRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
        //for the location picked on the map view by the user
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        //dnjkwndejknjk
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
    }
    
    
    @IBAction func createEvent(_ sender: Any) {
        
        if eventNameField.text != "" && locationNameTextField.text != "" && maxNumPlayersTextField.text != "" && minNumPlayersTextField.text != "" && eventDateTimeTextField.text != "" && long != 0.0 && lat != 0.0 {
            let newEventName = eventNameField.text!
            let newLocName = locationNameTextField.text!
            let newMinPlayers = minNumPlayersTextField.text!
            let newMaxPlayers = maxNumPlayersTextField.text!
            let newEventDateTime = eventDateTimeTextField.text!
            let lati = lat
            let longi = long
            
            
            let _ = databaseController?.addEvent(eventName: newEventName, eventDateTime: <#T##Date#>, numberOfPlayers: Int(newMaxPlayers) ?? 0, locationName: newLocName, long: Double(longi), lat: Double(lati), annotationImg: "", status: "", minNumPlayers: Int(newMinPlayers) ?? 0)
            navigationController?.popViewController(animated: true)
            return
        }
        
        var errorMsg = "Please ensure all fields are filled:\n"
        
        if eventNameField.text == "" {
            errorMsg += "- Must provide a event name\n"
        }
        if locationNameTextField.text == "" {
            errorMsg += "- Must provide location name"
        }
        if maxNumPlayersTextField.text == "" {
            errorMsg += "- Must provide max number of players"
        }
        
        if minNumPlayersTextField.text == "" {
            errorMsg += "- Must provide min number of players"
        }
        
        if eventDateTimeTextField.text == "" {
            errorMsg += "- Must provide event date and time"
        }
        
        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
                                                    UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //to know where the user tapped on the map
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            lat = 0.0
            long = 0.0
            addAnnotation(location: locationOnMap)
        }
    }
    
    //add an annotation where the user tapped
    func addAnnotation(location: CLLocationCoordinate2D){
        let allAnnotations = self.mapView.annotations
        if (allAnnotations.count > 0){
            self.mapView.removeAnnotations(allAnnotations)
        }else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            lat = location.latitude
            long = location.longitude
            print(location)
            print (lat)
            print (long)
            annotation.title = "Your Location"
            annotation.subtitle = ""
            self.mapView.addAnnotation(annotation)
        }
    }
}

func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
    
    let reuseId = "pin"
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView!.canShowCallout = true
        pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        pinView!.pinTintColor = UIColor.black
    }
    else {
        pinView!.annotation = annotation
    }
    return pinView
}

func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("tapped on pin ")
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
        if (view.annotation?.title!) != nil {
        }
    }
}
