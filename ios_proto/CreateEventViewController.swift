//
//  CreateEventViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 21/11/20.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?

    //add all the text fields

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    @IBAction func createEvent(_ sender: Any) {
        
//        if eventNameTextField.text != "" && abilitiesTextField.text != "" {
//            let eventName = eventNameTextField.text!
//            let abilities = abilitiesTextField.text!
//            let _ = databaseController?.addEvent(name: name, abilities: abilities)
//            navigationController?.popViewController(animated: true)
//            return
//        }
//
//        var errorMsg = "Please ensure all fields are filled:\n"
//
//        if nameTextField.text == "" {
//            errorMsg += "- Must provide a event name\n"
//        }
//        if abilitiesTextField.text == "" {
//            errorMsg += "- Must provide abilities"
//        }
//
//        displayMessage(title: "Not all fields filled", message: errorMsg)
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
            UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
