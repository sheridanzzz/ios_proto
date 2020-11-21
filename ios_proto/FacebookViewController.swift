//
//  FacebookViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import UIKit
import FacebookCore
import FacebookLogin

class FacebookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loginButton = FBLoginButton()
        // This can place the login button at the center of your view
        loginButton.center = view.center
        view.addSubview(loginButton)
        loginButton.permissions = ["public_profile","email"]
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
