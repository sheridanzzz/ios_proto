//
//  EventTableViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 20/11/20.
//

import UIKit

class EventTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating {
    
    let CELL_EVENT = "eventCell"
    
    var allEvents: [Events] = []
    var filteredEvents: [Events] = []
    weak var eventDelegate: AddEventDelegate?
    weak var databaseController: DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredEvents = allEvents
        //print(allEvents)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
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
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return filteredEvents.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCell(withIdentifier: CELL_EVENT,
                                                      for: indexPath) as! EventTableViewCell
        let event = filteredEvents[indexPath.row]
        eventCell.eventNameLabel.text = event.eventName
        return eventCell
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        //        cell.textLabel?.text = "\(allHeroes.count) heroes in the database"
        //        cell.textLabel?.textColor = .secondaryLabel
        //        cell.selectionStyle = .none
        //        return cell
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        
        if eventDelegate?.addEvent(newEvent: filteredEvents[indexPath.row]) ?? false {
            navigationController?.popViewController(animated: false)
            
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        displayMessage(title: "Party Full", message: "Unable to add more members to party")
    }
    
    
    // MARK: - Database Listener
    func onEventListChange(change: DatabaseChange, events: [Events]) {
        allEvents = events
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func onSportListChange(change: DatabaseChange, sports: [Sports]) {
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
