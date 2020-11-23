//
//  EventTableViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 20/11/20.
//

import UIKit
import Kingfisher

class EventTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    
    
    let CELL_EVENT = "eventCell"
    
    var allEvents: [Events] = []
    var filteredEvents: [Events] = []
    weak var eventDelegate: AddEventDelegate?
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredEvents = allEvents
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.jpg"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Search Controller Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        print(searchText)
        if searchText.count > 0 {
            filteredEvents = allEvents.filter({ (event: Events) -> Bool in
                return event.eventName?.lowercased().contains(searchText) ?? false
            })
        } else {
            filteredEvents = allEvents
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: CELL_EVENT,
                                                      for: indexPath) as! EventTableViewCell
        let event = filteredEvents[indexPath.row]
        eventCell.eventNameLabel.text = event.eventName
        eventCell.sportNameLabel.text = event.sport
        eventCell.iconImageView.downloaded(from: event.annotationImg ?? "")
        return eventCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        
        self.performSegue(withIdentifier: "eventDetailsSegue", sender: self)
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
    
    
    // MARK: - Database Listener
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        allEvents = events
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
        //do nothing
    }
    
    func onUserListChange(change: DatabaseChange, users: [Users]) {
        //do nothing
    }
    
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//used for downloading the image
extension UIImageView {
    func downloaded2(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
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
    func downloaded2(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
