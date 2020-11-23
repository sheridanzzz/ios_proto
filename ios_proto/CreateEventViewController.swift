//
//  CreateEventViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 21/11/20.
//

import UIKit
import MapKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class CreateEventViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, DatabaseListener{
    
    //references
    //date time pickerhttps://stackoverflow.com/questions/49991549/date-time-picker-in-swift-4
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var locationNameTextField: UITextField!
    @IBOutlet weak var maxNumPlayersTextField: UITextField!
    @IBOutlet weak var minNumPlayersTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDateTimeTextField: UITextField!
    
    @IBOutlet weak var sportPicker: UIPickerView!
    
    var lat = 0.0
    var long = 0.0
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    
    private var datePicker: UIDatePicker?
    
    var selectedSport: String?
    var sportText: String?
    var pickerData: [String] = [String]()
    var dateText: String?
    var dateMain: Date?
    var newEvent: Events?
    var pickedSport: Sports?
    var allSports: [Sports] = []
    var sportNames: [String] = []
    var eventImageURL: String?
    
    var currentUserId: String? = nil
    var db: Firestore?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        
        self.sportPicker.dataSource = self
        self.sportPicker.delegate = self
        
        
        //date picker for the user to pick the date
        datePicker = UIDatePicker()
        let currentDate = Date()  //get the current date
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.minimumDate = currentDate
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
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = #colorLiteral(red: 0.224999994, green: 0.3549999893, blue: 1, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        toolBar.setItems([doneButton], animated: true)
        
        
        toolBar.isUserInteractionEnabled = true
        eventDateTimeTextField.inputAccessoryView = toolBar
        
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
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        eventDateTimeTextField.text = dateFormatter.string(from: datePicker.date)
        let strDate = dateFormatter.string(from: datePicker.date)
        dateText = strDate
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateMain = datePicker.date
        view.endEditing(true)
        
    }
    
    
    @IBAction func createEvent(_ sender: Any) {
        
        
        if eventNameField.text != "" && locationNameTextField.text != "" && maxNumPlayersTextField.text != "" && minNumPlayersTextField.text != "" && eventDateTimeTextField.text != "" && long != 0.0 && lat != 0.0 && sportText != ""{
            let newEventName = eventNameField.text!
            let newLocName = locationNameTextField.text!
            let newMinPlayers = minNumPlayersTextField.text!
            let newMaxPlayers = maxNumPlayersTextField.text!
            _ = eventDateTimeTextField.text!
            let lati = lat
            let longi = long
            
            //get current user id
            guard let userID = Auth.auth().currentUser?.uid else { return }
            
            print("user id")
            print(userID)
            
            let _ = self.databaseController?.addEvent(eventName: newEventName, eventDateTime: dateMain!, numberOfPlayers: Int(newMaxPlayers) ?? 0, locationName: newLocName, long: Double(longi), lat: Double(lati), annotationImg: eventImageURL ?? "on" , status: "ON", minNumPlayers: Int(newMinPlayers) ?? 0, sport: sportText ?? "", uuid: userID )
            
            navigationController?.popViewController(animated: true)
            return
        }
        
        let max = Int(maxNumPlayersTextField.text ?? "")
        
        let min = Int(minNumPlayersTextField.text ?? "")!
        
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
        
        if long == 0.0 {
            errorMsg += "- Must provide location\n"
        }
        
        if sportText == "" {
            errorMsg += "- Must select a sport\n"
        }
        
        if min > max ?? 1{
            errorMsg += "- Min players cant be more than max players\n"
        }
        
        if min == 0 || max == 0 {
            errorMsg += "- must have more than 0 players\n"
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedSport = pickerData[row]
        sportText = selectedSport
        
        pickedSport = allSports[row];
        eventImageURL = pickedSport?.sportsImg;
    }
    
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        //nothing
    }
    
    func onUserListChange(change: DatabaseChange, users: [Users]) {
        //do nothing
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
        allSports = sports
        for sport in allSports{
            sportNames.append(sport.sportName ?? "")
        }
        pickerData = sportNames
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
