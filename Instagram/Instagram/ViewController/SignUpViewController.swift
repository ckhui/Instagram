//
//  signUpViewController.swift
//  Instagram
//
//  Created by NEXTAcademy on 11/14/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    
    //dolinking 
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var profileImagePreview: UIImageView!
    //link
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //imageView
        profileImagePreview.layer.borderWidth = 3.0
        profileImagePreview.layer.borderColor = UIColor.blue.cgColor
    }

    @IBAction func onCreateUserPressed(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
            
            //TODO: if email ald exist
            
            if let createAccountError = error {
                print("Creat Account error : \(createAccountError)")
                
                return
            }
            
            self.creatAccountSuccessfulPopUp(userName: self.usernameTextField.text, email: email)
            
            //display create account successfuly message
            
            //testing
            print("just created user")
            self.currentUserInfo()
            print("done created user -- log out")
            
            //avoid logged in directly after account successfully created
            try! FIRAuth.auth()!.signOut()
            self.currentUserInfo()
            
        }
        
        print("created process done")
        currentUserInfo()
    }
    
    
    func creatAccountSuccessfulPopUp(userName: String?,email: String?){
        let message = "Account creted with \nUsername : \(userName) \nEmail : \(email)"
        let successfullyCreatedAccountAlert = UIAlertController(title:"Account Successful Creatd", message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        successfullyCreatedAccountAlert.addAction(okButton)
        
        present(successfullyCreatedAccountAlert, animated: true, completion: nil)
    }
    
    
    func currentUserInfo(){
        if let user = FIRAuth.auth()?.currentUser{
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
            print("Current User with name : \(name) email:\(email)")
            
            for profile in user.providerData {
                let providerID = profile.providerID
                let uid = profile.uid;  // Provider-specific UID
                let name = profile.displayName
                let email = profile.email
                let photoURL = profile.photoURL
            }
            
        } else {
            print ("NO user logggggggggged in ")
            // No user is signed in.
        }
    }
    
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "backToLoginPage", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "backToLoginPage" {
            
        }
        else if segue.identifier == "signInToSelectPhoto" {
            let vc : imagepickerViewController = segue.destination as! imagepickerViewController
            vc.currentImage = profileImagePreview.image!
            vc.delegate = self
            
        }
        return
    }
    
    @IBAction func onChoosePhotoButtonPressed(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "signInToSelectPhoto", sender: self)
    }
}
