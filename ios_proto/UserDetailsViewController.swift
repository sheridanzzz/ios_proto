//
//  UserDetailsViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 23/11/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UserDetailsViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, DatabaseListener {
    
    
    let CELL_USEREVENT = "userEventsCell"
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var userEventsTable: UITableView!
    @IBOutlet weak var postcodeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    var firstName: String = ""
    var lastName: String = ""
    var dob: String = ""
    var state: String = ""
    var gender: String = ""
    var profilePic: String = ""
    var postcode: Int = 0
    var uuid: String = ""
    
    var currentUserId: String? = nil
    var db: Firestore?
    
    var allEvents: [Events] = []
    var filteredEvents: [Events] = []
    
    var allUsers: [Users] = []
    
    var eventName: String = ""
    var eventDateTime: String = ""
    var locName: String = ""
    var NoOfPlayers: String = ""
    var minNoOfPlayers: String = ""
    var sportType: String = ""
    var icon: String = ""
    var lat: Double = 0.0
    var long: Double = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEventsTable.delegate = self
        userEventsTable.dataSource = self
        
        
        firstNameLabel.text = "First Name:" + " " + firstName
        lastNameLabel.text =  "Last Name:" + " " + lastName
        dateOfBirthLabel.text = "Date of Birth:" + " " + dob
        genderLabel.text = "Gender:" + " " + gender
        postcodeLabel.text = "Postcode:" + " " + String(postcode)
        stateLabel.text = "State:" + " " + state
        
        profileImageView.downloaded(from: profilePic)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background.jpg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //shows the events the user created on the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userEventCell = tableView.dequeueReusableCell(withIdentifier: CELL_USEREVENT,
                                                          for: indexPath) as! UserEventTableViewCell
        let event = filteredEvents[indexPath.row]
        userEventCell.eventNameLabel.text = event.eventName
        userEventCell.sportNameLabel.text = event.sport
        userEventCell.eventImageView.downloaded(from: event.annotationImg ?? "")
        return userEventCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let event = filteredEvents[indexPath.row]
        eventName = event.eventName ?? ""
        eventDateTime = df.string(from: event.eventDateTime!)
        locName = event.locationName ?? ""
        NoOfPlayers = String(event.numberOfPlayers!)
        minNoOfPlayers = String(event.minNumPlayers!)
        sportType = event.sport ?? ""
        icon = event.annotationImg ?? ""
        lat = event.lat!
        long = event.long!
        
        
        self.performSegue(withIdentifier: "userEventsSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EventsDetailsViewController
        {
            let ed = segue.destination as? EventsDetailsViewController
            ed?.name = eventName
            ed?.dateTime = eventDateTime
            ed?.location = locName
            ed?.noOfPlayers = NoOfPlayers
            ed?.minNoOfPlayers = minNoOfPlayers
            ed?.sportType = sportType
            ed?.icon = icon
            ed?.lat = lat
            ed?.long = long
        }
    }
    
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        allEvents = events
        
        //gets the events the user created
        for event in allEvents{
            if event.uuid == uuid {
                filteredEvents.append(event)
            }
        }
        
        print(filteredEvents.count)
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
        //DO NOTHING
    }
    
    func onUserListChange(change: DatabaseChange, users: [Users]) {
        //nothing
    }
}
