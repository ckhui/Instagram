//
//  LoginViewController.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    //dolinking
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton! { didSet{
        signupButton.addTarget(self, action: #selector(loginButtonTapped(button:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton! { didSet{
        loginButton.addTarget(self, action: #selector(createAccountButtonTapped(button:)), for: .touchUpInside)
        }
    }
    //link
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedInUser()
        // Do any additional setup after loading the view.
    }
    
    
    func checkLoggedInUser(){
        if FIRAuth.auth()?.currentUser == nil{
            print("No user right now, wakakakaka")
        }
        else{
            print("there ald some user, sorry")
            notifyExistLoggedInUser()
        }
    }
    
    
    func loginButtonTapped(button: UIButton)
    {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text
            else
        {   // warn user that they need to enter username or password
            
            Instagram().warningPopUp(withTitle: "Error", withMessage: "email and name error", viewController: self)
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: {(user, error) in
            //if no error and user exist
            if let authError = error {
                //display the error
                print("login error \(authError)")
                //TODO: password error
                Instagram().warningPopUp(withTitle: "Log in Error", withMessage: "password and email not match", viewController: self)
                
                return
            }
            
            guard let _ = user else {
                //auth sucess but user not found
                //weird bug
                return
            }
            
            //testing
            print("loggged in")
            self.currentUserInfo()
            print("loggged in")
            
            self.notifySuccessLogin()
        })
    }
    
    
    func notifySuccessLogin ()
    {
        let AuthSuccessNotification = Notification (name: Notification.Name(rawValue: "AuthSuccessNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(AuthSuccessNotification)
    }
    
    func notifyExistLoggedInUser ()
    {
        let ExistLoggedInUserNotification = Notification (name: Notification.Name(rawValue: "ExistLoggedInUserNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(ExistLoggedInUserNotification)
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
            print("No user signed in ")
            // No user is signed in.
        }
    }
    
    
    func createAccountButtonTapped(button: UIButton){
        performSegue(withIdentifier: "toSignUpPage", sender: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSignUpPage"){
            return
        }
    }
    
    
    
}

