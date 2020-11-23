//
//  UserDetailsViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 23/11/20.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var postcodeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    var firstName: String = ""
    var lastName: String = ""
    var dob: String = ""
    var state: String = ""
    var gender: String = ""
    var profilePic: String = ""
    var postcode: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameLabel.text = "First Name:" + " " + firstName
        lastNameLabel.text =  "Last Name:" + " " + lastName
        dateOfBirthLabel.text = "Date of Birth:" + " " + dob
        genderLabel.text = "Gender:" + " " + gender
        postcodeLabel.text = "Postcode:" + " " + String(postcode)
        stateLabel.text = "State:" + " " + state
        
        profileImageView.downloaded(from: profilePic)

        // Do any additional setup after loading the view.
    }
}
