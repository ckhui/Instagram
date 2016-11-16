//
//  Instagram.swift
//  Instagram
//
//  Created by NEXTAcademy on 11/16/16.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage


class Instagram {
    
    var dateFormatter = DateFormatter(){
        didSet{
            dateFormatter.dateFormat = "dd MM yyyy"
        }
    }
    
    func timeAgo(timestamp : TimeInterval) -> String{
        let currentDate = Date(timeIntervalSince1970: timestamp)
        let diffInTime = -(currentDate.timeIntervalSinceNow)
        let min = diffInTime.divided(by: 60.0)
        
        if min < 3{
            return "just now"
        }
            
        else if min < 60{
            return "\(Int(min))min ago"
        }
        
        let hour = min.divided(by: 60.0)
        if hour < 24{
            if hour == 1{
                return "\(Int(hour))hour ago"
            }
            return "\(Int(hour))hours ago"
        }
        
        let day = hour.divided(by: 24.0)
        if day < 8{
            if day == 1{
                return "\(Int(day))day ago"
            }
            return "\(Int(day))days ago"
        }
        
        return dateFormatter.string(from: currentDate)
    }
    
    func uploadImage(_ image: UIImage,forUser user: FIRUser? ,atPath path : String)
    {
        let frStorage = FIRStorage.storage().reference()
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            UIViewController().warningPopUp(withTitle: "Image Type Error", withMessage: "Image Type Error")
            return
        }
        
        // Create a reference to the file you want to upload
        //let riversRef = storageRef.child("images/rivers.jpg")
        
        
        let newMetadata = FIRStorageMetadata()
        newMetadata.contentType = "image/jpeg"
        
        var profilePath = "profilePict-demo.jpeg"
        
        // this is a sample to use USERID to name the uploaded image
        if let firUser = user{
            let userID = firUser.uid
            profilePath = "profilePict/\(userID).jpeg"
        }
        
        var downloadURL : URL?
        
        //upload image
        frStorage.child(profilePath).put(imageData, metadata: newMetadata, completion: {
            (storageMeta, error) in
            if let uploadError = error
            {
                print (uploadError)
                
                //this is to debug only
                assertionFailure("Failed to upload")    // dont do this on production
            }
            else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                downloadURL = storageMeta!.downloadURL()
            }
        })
        
        //save url
        
        
    }
    
    func uploadProfileImage ()
    {
        let image = UIImage(named: "UProfile")!
        //uploadImage(image, of: nil)
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
    
    func modifyDatabse(path: String,key: String,value: String){
        var frDBref: FIRDatabaseReference!
        frDBref = FIRDatabase.database().reference()
        frDBref.child("\(path)/\(key)").setValue(value)
    }
    
    func modifyDatabse(path: String,dictionary : [String : String]){
        var frDBref: FIRDatabaseReference!
        frDBref = FIRDatabase.database().reference()
        frDBref.child("\(path)/").setValue(dictionary)
    }
    
    

}


extension UIViewController{
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popUP.addAction(okButton)
        present(popUP, animated: true, completion: nil)
    }
}

