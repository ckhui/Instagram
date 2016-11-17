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
        signupButton.addTarget(self, action: #selector(createAccountButtonTapped(button:)), for: .touchUpInside)    }}
    
    @IBOutlet weak var loginButton: UIButton! { didSet{
        loginButton.addTarget(self, action: #selector(loginButtonTapped(button:)), for: .touchUpInside)    }}
    //link
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedInUser()
    }
    
    func checkLoggedInUser(){
        if FIRAuth.auth()?.currentUser == nil{
            print("No user right now, you can login")
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
            
            self.warningPopUp(withTitle: "Error", withMessage: "email and name error")

            return
        }
        
        //TODO : validate empty input
        //TODO: check email format
        
        FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: {(user, error) in
            //if no error and user exist
            if let authError = error {
                //display the error
                print("login error \(authError)")
                
                self.warningPopUp(withTitle: "Log in Error", withMessage: "password and email not match")
                
                return
            }
            
            //testing
            print("loggged in")
            Instagram().currentUserInfo()
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
    
    
    func createAccountButtonTapped(button: UIButton){
        performSegue(withIdentifier: "toSignUpPage", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSignUpPage"){
            return
        }
    }
    
    
    
}

