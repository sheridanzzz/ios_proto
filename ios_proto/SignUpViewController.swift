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
                    self.performSegue(withIdentifier: "SignUpToHome", sender: self)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
