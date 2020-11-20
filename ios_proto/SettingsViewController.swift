//
//  SettingsViewController.swift
//  ios_proto
//
//  Created by user173239 on 11/21/20.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsViewController: UIViewController {
    @IBOutlet weak var uuid_textField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
            self.uuid_textField.text = auth.currentUser?.uid
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
