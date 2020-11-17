//
//  LoginViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var pass_textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = UIImage(named: "SportsCentralLogo.png")
        // Do any additional setup after loading the view.
    }
    @IBAction func login_button(_ sender: Any) {
    }
    @IBAction func facebook_button(_ sender: Any) {
    }
    @IBAction func register_button(_ sender: Any) {
    }
    @IBAction func forgot_button(_ sender: Any) {
    }
}
