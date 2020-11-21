//
//  SignUpViewController.swift
//  ios_proto
//
//  Created by user173239 on 11/17/20.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var pass_textField: UITextField!
    @IBOutlet weak var retype_pass_textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func register_button(_ sender: Any) {
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
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    
                    //I COMMENTEDT THIS LINE OUT
                    
                    //self.performSegue(withIdentifier: "SignUpToHome", sender: self)
                }
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
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
                                                    UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
