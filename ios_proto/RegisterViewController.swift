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
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var password_textField: UITextField!
    @IBOutlet weak var gender_pickerView: UIPickerView!
    @IBOutlet weak var date_datePicker: UIDatePicker!
    @IBOutlet weak var state_textField: UITextField!
    @IBOutlet weak var postcode_textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func register_button(_ sender: Any) {
        if let email = email_textField.text, let password = password_textField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                }
                else {
                    
                }
            }
        }
    }
    
    
}
