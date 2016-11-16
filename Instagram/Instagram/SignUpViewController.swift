//
//  SignUpViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    
    //dolinking
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var cancleButton: UIButton! { didSet{
        cancleButton.addTarget(self, action: #selector(onCancelButtonTapped(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var choosePhotoButton: UIButton! { didSet{
        choosePhotoButton.addTarget(self, action: #selector(onChoosePhotoButtonPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var createButton: UIButton! { didSet{
        createButton.addTarget(self, action: #selector(onCreateUserPressed(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var profileImagePreview: UIImageView!
    //link
    var frDBref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frDBref = FIRDatabase.database().reference()
        
        //imageView.border
        profileImagePreview.layer.borderWidth = 3.0
        profileImagePreview.layer.borderColor = UIColor.blue.cgColor
    }
    
    func onCreateUserPressed(button: UIButton) {
        //TODO : more specific email and username validation, regular expression
        guard let username = usernameTextField.text
            else{
                return
        }
        if username == ""{
            warningPopUp(withTitle: "Username", withMessage: "Cannot be empty")
            return
        }
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email == "" || password == ""{
            warningPopUp(withTitle: "input error", withMessage: "empty email or password")
            return
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
            
            //TODO: if email ald exist
            
            if let createAccountError = error {
                print("Creat Account error : \(createAccountError)")
                return
            }
            
            guard let currentUser = user else{
                print ("impossible current user not found error")
                return
            }
            
            //update user info
            let changeRequest = currentUser.profileChangeRequest()
            
            changeRequest.displayName = username
            
            //TODO : update image and get url
            let imageURL = "https://firebasestorage.googleapis.com/v0/b/instagram-1eebe.appspot.com/o/ProfilePicture%2Fadmin2.jpg?alt=media&token=521b91d2-d5e3-4120-a9ab-b47ab07f7903"
            
            
            changeRequest.photoURL =
                URL(string: "https://firebasestorage.googleapis.com/v0/b/instagram-1eebe.appspot.com/o/ProfilePicture%2Fadmin2.jpg?alt=media&token=521b91d2-d5e3-4120-a9ab-b47ab07f7903")
            
            changeRequest.commitChanges(completion: { error in
                if let error = error {
                    // An error happened.
                    print("upload user info error : \(error)")
                } else {
                    // Profile updated.
                }
            })
            
            self.creatAccountSuccessfulPopUp(userName: self.usernameTextField.text, email: email)
            
            
            let path = "User/\(currentUser.uid)"
            
            var tempDict = [String : String]()
            tempDict["name"] = username
            tempDict["picture"] = imageURL

            Instagram().modifyDatabse(path: path, dictionary: tempDict)
            
            //testing
            print("just created user")
            Instagram().currentUserInfo()
            print("done creating user -- log out")
            
            //avoid logged in directly after account successfully created
            try! FIRAuth.auth()!.signOut()
            Instagram().currentUserInfo()
            
        }
        
        print("created process done")
        Instagram().currentUserInfo()
        
        //go back
        dismiss(animated: true, completion: nil)
    }
    
    
    func creatAccountSuccessfulPopUp(userName: String?,email: String?){
        let message = "Account creted with \nUsername : \(userName) \nEmail : \(email)"
        let title = "Account Successful Create"
        warningPopUp(withTitle: title, withMessage: message)
    }
    
    func onCancelButtonTapped(button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInToSelectPhoto" {
            //let vc : imagepickerViewController = segue.destination as! imagepickerViewController
            //vc.currentImage = profileImagePreview.image!
            //vc.delegate = self
            
        }
        return
    }
    
    func onChoosePhotoButtonPressed(button: UIButton) {
        
        performSegue(withIdentifier: "signInToSelectPhoto", sender: self)
    }
}
