//
//  RegisterViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var fName_textField: UITextField!
    @IBOutlet weak var lName_textField: UITextField!
    @IBOutlet weak var gender_pickerView: UIPickerView!
    @IBOutlet weak var dob_datePicker: UIDatePicker!
    @IBOutlet weak var state_textField: UITextField!
    @IBOutlet weak var postcode_textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp_button(_ sender: Any) {
        
    }
    
}
