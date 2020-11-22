//
//  RegisterViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var pass_textField: UITextField!
    @IBOutlet weak var retype_pass_textField: UITextField!
    @IBOutlet weak var fname_textField: UITextField!
    @IBOutlet weak var lname_textField: UITextField!
    @IBOutlet weak var gender_pickerView: UIPickerView!
    @IBOutlet weak var date_datePicker: UIDatePicker!
    @IBOutlet weak var state_textField: UITextField!
    @IBOutlet weak var postcode_textField: UITextField!
    
    var selectedGender: String?
    var gender_text: String?
    var pickerData: [String] = [String]()
    var dateText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        self.gender_pickerView.dataSource = self
        self.gender_pickerView.delegate = self
        pickerData = ["Male", "Female", "Not Specified"]
    }
    
    @IBAction func datePicker_changed(_ sender: Any) {
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short

        let strDate = dateFormatter.string(from: date_datePicker.date)
        dateText = strDate
    }
    
    @IBAction func register_button(_ sender: Any) {
        let firstName = fname_textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lname_textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let state = state_textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let postcode = postcode_textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let email = email_textField.text, let password = retype_pass_textField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    let alert = UIAlertController(title: "Error!", message: e.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                else {
                    // after login is done, maybe put this in the login web service completion block
                    
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":firstName, "lastName":lastName, "gender":self.gender_text, "state":state, "postcode":postcode, "uuid":authResult?.user.uid, "dateOfBirth":self.dateText, "profileImg": "",  "registerationDate":dateFormatter.string(from: date)]) { (error) in
                        
                        if error != nil {
                            //show error message
                            print(error)
                        }
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    
                    //I COMMENTEDT THIS LINE OUT
                    
                    //self.performSegue(withIdentifier: "SignUpToHome", sender: self)
                }
            }
            //add for all text fields
            //        if email_textField.text != "" && retype_pass_textField.text != "" {
            //            let email = email_textField.text!
            //            let password = retype_pass_textField.text!
            //            let _ = databaseController?.addUser(email: email, password: password)
            //            navigationController?.popViewController(animated: true)
            //            return
            //        }
            //
            //        var errorMsg = "Please ensure all fields are filled:\n"
            //
            //        if nameTextField.text == "" {
            //            errorMsg += "- Must provide a email\n"
            //        }
            //        if abilitiesTextField.text == "" {
            //            errorMsg += "- Must provide password"
            //        }
            //
            //        displayMessage(title: "Not all fields filled", message: errorMsg)
        }
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
                                                    UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           // This method is triggered whenever the user makes a change to the picker selection.
           // The parameter named row and component represents what was selected.
        selectedGender = pickerData[row]
        gender_text = selectedGender
    }
}

