//
//  SettingsViewController.swift
//  ios_proto
//
//  Created by user173239 on 11/21/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class SettingsViewController: UIViewController {
    @IBOutlet weak var uuid_textField: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var updateImage_button: UIButton!
    var image: UIImage? = nil
    var currentUserId: String? = nil
    var db: Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        // Do any additional setup after loading the view.
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            self.uuid_textField.text = auth.currentUser?.email
            let currUser = auth.currentUser?.uid
            print("Curr user")
            self.currentUserId = currUser
            print(self.currentUserId)
        }
        
        self.db?.collection("users").whereField("uuid", isEqualTo: self.currentUserId).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //print("HELLLLLLOOOOOOOO")
                //print(querySnapshot!.documents[0].data())
                for document in querySnapshot!.documents {
                    
                    let value = document.data()["profileImg"]
                    print("HELLLLLLOOOOOOOO")
                    print(value)
                    let url = URL(string: value as! String)
                    self.profileImg.kf.setImage(with: url)
                }
            }
        }
        
        profileImg.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profileImg.addGestureRecognizer(tapGesture)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background.jpg")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    @IBAction func updateImage_btnPressed(_ sender: Any) {
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://ios-project-56ff2.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(self.currentUserId!)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata, completion: { (StorageMetadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL(completion: { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    print(metaImageUrl)
                    //let db = Firestore.firestore()
                    self.db?.collection("users").whereField("uuid", isEqualTo: self.currentUserId!).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            //print("HELLLLLLOOOOOOOO")
                            //print(querySnapshot!.documents[0].data())
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                self.db?.collection("users").document(document.documentID).updateData(["profileImg" : metaImageUrl])
                            }
                        }
                    }
                    //print("UPDATING FIELDS")
                    
                        
                }
            })
        })
        
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func logout_button(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            navigationController?.popToRootViewController(animated: true)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            profileImg.image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            profileImg.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
