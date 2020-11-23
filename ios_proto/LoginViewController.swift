//
//  LoginViewController.swift
//  ios_proto
//
//  Created by Sheridan's Lair on 05/11/20.
//

import UIKit
import FirebaseAuth
import Firebase
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var email_textField: UITextField!
    @IBOutlet weak var pass_textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = UIImage(named: "SportsCentralLogo.png")
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        let loginButton = FBLoginButton()
        self.view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //loginButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        //NSLayoutConstraint(item: loginButton, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottomMargin, multiplier: 1.0, constant: 20.0).isActive = true
        // This can place the login button at the center of your view
        //loginButton.center = view.bottomAnchor
        view.addSubview(loginButton)
        loginButton.permissions = ["public_profile","email"]
        
        //background image
        UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "background.jpg")?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    //function to validate the fields
    func validateFields() -> String? {
        
        //CHeck all fields are filled in
        if email_textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pass_textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all fields!"
        }
        
        //Check if password is correct
        
        if pass_textField.text!.trimmingCharacters(in: .whitespacesAndNewlines).count <= 6 {
            return "Password should be more than 6 characters"
        }
        
        //Check if email is correct
        
        if self.isValidEmailAddress(emailAddressString: email_textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            return "Please enter email address in correct format!"
        }
        
        return nil
    }
    
    // regex for email address
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    @IBAction func login_button(_ sender: Any) {
        
        let err = validateFields()
        
        if err != nil {
            //let alert = UIAlertController()
            //alert.title = "Error!"
            //alert.message = err
            //alert.addButton(withTitle: "Dismiss")
            //alert.show()
            self.displayMessage(title: "Error!", message: err!)
            return
        }
        
        if let email = email_textField.text, let password = pass_textField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                if let e = error {
                    print(e)
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton!, didCompleteWith result: LoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Facebook authentication with Firebase error: ", error)
                return
            }
            print("Login success!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            
        }
    }
    
    @IBAction func register_button(_ sender: Any) {
    }
    @IBAction func forgot_button(_ sender: Any) {
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style:
                                                    UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
