//
//  EventsDetailsViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 22/11/20.
//

import UIKit
import MapKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class EventsDetailsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var minNumberOfPlayersLabel: UILabel!
    @IBOutlet weak var sportTypeLabel: UILabel!
    
    @IBOutlet weak var startEvent_button: UIButton!
    
    var name: String = ""
    var location: String = ""
    var dateTime: String = ""
    var noOfPlayers: String = ""
    var minNoOfPlayers: String = ""
    var sportType: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    var icon: String = ""
    var pin : MKPointAnnotation!
    var db: Firestore?
    var currentUserId: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUserId = auth.currentUser?.uid
        }
        
        eventNameLabel.text = "Event Name:" + " " + name
        eventDateTimeLabel.text =  "Event Date/Time:" + " " + dateTime
        locationNameLabel.text = "Location Name:" + " " + location
        numberOfPlayersLabel.text = "Max Number of Players:" + " " + noOfPlayers
        minNumberOfPlayersLabel.text = "Min Number of Players:" + " " + minNoOfPlayers
        sportTypeLabel.text = "Sport Type:" + " " + sportType
        
        eventImageView.downloaded(from: icon)
        
        mapView.delegate = self
        
        let latitude:CLLocationDegrees = lat
        let longitude:CLLocationDegrees = long
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let zoomRegion = MKCoordinateRegion(center: location, latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Event Location"
        annotation.subtitle = ""
        self.mapView.addAnnotation(annotation)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
                    UIImage(named: "background.jpg")?.draw(in: self.view.bounds)
                    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    @IBAction func startEventBtn(_ sender: Any) {
    }
    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                var image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

func resize(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
