//
//  ChannelsTableViewController.swift
//  ios_proto
//
//  Created by user173239 on 11/22/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChannelsTableViewController: UITableViewController {
    
    let CHANNEL_SEGUE = "channelSegue"
    let CHANNEL_CELL = "channelCell"
    var currentSender: Sender?
    var channels = [Channel]()
    
    var channelsRef: CollectionReference?
    var databaseListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let database = Firestore.firestore()
        channelsRef = database.collection("channels")
        
        navigationItem.title = "Channels List"
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            
            self.currentSender = Sender(id: auth.currentUser?.uid ?? "000", name: "Hamza")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background.jpg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    @IBAction func addChannel(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Channel",
                                                message: "Enter channel name below", preferredStyle: .alert)
        alertController.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Create", style: .default) { _ in
            let channelName = alertController.textFields![0]
            
            var doesExist = false
            
            for channel in self.channels {
                if channel.name.lowercased() == channelName.text!.lowercased() {
                    doesExist = true
                }
            }
            
            if !doesExist {
                self.channelsRef?.addDocument(data: [
                    "name" : channelName.text!
                ])
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        databaseListener = channelsRef?.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error)
                return
            }
            
            self.channels.removeAll()
            
            querySnapshot?.documents.forEach({snapshot in
                let id = snapshot.documentID
                let name = snapshot["name"] as! String
                let channel = Channel(id: id, name: name)
                
                self.channels.append(channel)
            })
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        databaseListener?.remove()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt
                                indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CHANNEL_CELL,
                                                 for: indexPath)
        let channel = channels[indexPath.row]
        
        cell.textLabel?.text = channel.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
                                indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
                                indexPath: IndexPath) {
        let channel = channels[indexPath.row]
        performSegue(withIdentifier: CHANNEL_SEGUE, sender: channel)
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CHANNEL_SEGUE {
            let channel = sender as! Channel
            let destinationVC = segue.destination as! ChatMessagesViewController
            
            destinationVC.sender = currentSender
            destinationVC.currentChannel = channel
        }
    }
    
    
}
