//
//  SearchUsersTableViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 23/11/20.
//

import UIKit

class SearchUsersTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    
    

    let CELL_USER = "userCell"
    
    var allUsers: [Users] = []
    var filteredUsers: [Users] = []
    //weak var userDelegate: AddEventDelegate?
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    var userName: String = ""
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
        
        filteredUsers = allUsers
        //print(allEvents)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchController
        
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
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
            filteredUsers = allUsers.filter({ (user: Users) -> Bool in
                return user.firstName?.lowercased().contains(searchText) ?? false
            })
        } else {
            filteredUsers = allUsers
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return filteredUsers.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: CELL_USER,
                                                      for: indexPath) as! SearchUserTableViewCell
        let user = filteredUsers[indexPath.row]
        print(user)
        userCell.userNameLabel.text = user.firstName
        return userCell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let df = DateFormatter()
//        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
//        let event = filteredEvents[indexPath.row]
//        eventName = event.eventName ?? ""
//        eventDateTime = df.string(from: event.eventDateTime!)
//        locName = event.locationName ?? ""
//        NoOfPlayers = String(event.numberOfPlayers!)
//        minNoOfPlayers = String(event.minNumPlayers!)
//        sportType = event.sport ?? ""
//        icon = event.annotationImg ?? ""
//        lat = event.lat!
//        long = event.long!
//
//
//        self.performSegue(withIdentifier: "eventDetailsSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: false)
            return
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.destination is EventsDetailsViewController
//        {
//            let ed = segue.destination as? EventsDetailsViewController
//            ed?.name = eventName
//            ed?.dateTime = eventDateTime
//            ed?.location = locName
//            ed?.noOfPlayers = NoOfPlayers
//            ed?.minNoOfPlayers = minNoOfPlayers
//            ed?.sportType = sportType
//            ed?.icon = icon
//            ed?.lat = lat
//            ed?.long = long
////            ed?.icon = imageIcon
////            ed?.pin = loco
//        }
//    }
    
    
    // MARK: - Database Listener
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        //do nothing
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
        //do nothing
    }
    
    func onUserListChange(change: DatabaseChange, users: [Users]) {
        allUsers = users
        print(allUsers.count)
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
