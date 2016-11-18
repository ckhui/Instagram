//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by NEXTAcademy on 11/18/16.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class EditProfileViewController: UIViewController {
    @IBOutlet weak var profilePhotoImage: UIImageView!
    @IBOutlet weak var bioImage: UIImageView!
    @IBOutlet weak var websiteImage: UIImageView!
    @IBOutlet weak var usernameImage: UIImageView!
    @IBOutlet weak var fullNameImage: UIImageView!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var cancelEditingbutton: UIBarButtonItem!{
        didSet{
            cancelEditingbutton.action = #selector(didCancelEditing)
        }
    }
    @IBOutlet weak var doneEditingButton: UIBarButtonItem!{
        didSet{
            doneEditingButton.action = #selector(didFinishEditing)
        }
    }
    
    
    
    var users = User()
//    var userUID = Instagram().currentUserUid()
    var ref1:FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref1 = FIRDatabase.database().reference()
        
        self.fullNameTextField.placeholder = "Name"
        self.usernameTextField.placeholder = "Username"
        self.websiteTextField.placeholder = "Website"
        self.bioTextField.placeholder = "Bio"
        
        
        self.fullNameImage.image = #imageLiteral(resourceName: "editName")
        self.usernameImage.image = #imageLiteral(resourceName: "editUsername")
        self.websiteImage.image = #imageLiteral(resourceName: "editWebsite")
        self.bioImage.image = #imageLiteral(resourceName: "editBio")
        
        fetchUserInfo()
        
    }
    
    
   
    //MARK: - Profile photo image set
    func fetchUserInfo() {
        
        
        ref1.child("User").child("Admin1").observeSingleEvent(of: .value, with: {(snapshot) in
            
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    print("hello")
                    self.users.desc = (dictionary["desc"] as! String?)!
                    self.users.name = (dictionary["name"] as! String?)!
                    self.users.picture = (dictionary["picture"] as! String?)!
                    self.profilePhotoImage.loadImageUsingCacheWithUrlString(self.users.picture)
                    self.fullNameTextField.text = self.users.name
                    self.bioTextField.text = self.users.desc
                }
        })
        
    }
    
    
    //MARK: - Finish Editing
    func didFinishEditing() {
        print("waddup")
        
        guard let fullname = self.fullNameTextField.text else{
            print("error")
            return
        }
        guard let descrip = self.bioTextField.text else {
            print("error")
            return
        }
        
        
        
        let dict = Instagram().prepareProfileDictionary(name: fullname , desc: descrip, imageUrl: self.users.picture)

        Instagram().instagramAction(type: .editProfile, dict: dict, targetUid: "Admin1")
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    func didCancelEditing(){
        self.performSegue(withIdentifier: "profileSegue", sender: self)

    }
    
    
    
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            let controller : ProfileCollectionViewController = segue.destination as! ProfileCollectionViewController
        }
    }
    
    
    
}
