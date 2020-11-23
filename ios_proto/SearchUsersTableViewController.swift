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
    
    var firstName: String = ""
    var lastName: String = ""
    var dob: String = ""
    var state: String = ""
    var gender: String = ""
    var profilePic: String = ""
    var postcode: Int = 0
    var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredUsers = allUsers
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return filteredUsers.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: CELL_USER,
                                                      for: indexPath) as! SearchUserTableViewCell
        let user = filteredUsers[indexPath.row]
        userCell.userNameLabel.text = user.firstName
        userCell.lastNameLabel.text = user.lastName
        userCell.profileImageLabel.downloaded(from: user.profileImg ?? "" )
        return userCell
    }
    
    
    //check which user selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = filteredUsers[indexPath.row]
        print(postcode)
        firstName = user.firstName ?? ""
        lastName = user.lastName ?? ""
        gender = user.gender ?? ""
        dob = user.dateOfBirth ?? ""
        postcode = user.postcode ?? 0
        profilePic = user.profileImg ?? ""
        state = user.state ?? ""
        uuid = user.uuid ?? ""
        
        self.performSegue(withIdentifier: "userDetailsSegue", sender: self)
            tableView.deselectRow(at: indexPath, animated: false)
            return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is UserDetailsViewController
        {
            let ed = segue.destination as? UserDetailsViewController
            ed?.firstName = firstName
            ed?.lastName = lastName
            ed?.gender = gender
            ed?.dob = dob
            ed?.profilePic = profilePic
            ed?.state = state
            ed?.postcode = postcode
            ed?.uuid = uuid
        }
    }
    
    
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
        print("user")
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
