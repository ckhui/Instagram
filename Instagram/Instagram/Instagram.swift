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
    
    var frDBref: FIRDatabaseReference!
    init(){
        frDBref = FIRDatabase.database().reference()
    }
    
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
    
    enum uploadImageType{
        case profilePicture
        case postInsta
    }
    
    func uploadImageToStorageAndGetUrl(type : uploadImageType, image : UIImage,fileName : String?) -> String{
        let str = ""
        //get image data and metadata
        //create image path
        //sava image , return url
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
            UIViewController().warningPopUp(withTitle: "Image Type Error", withMessage: "Image Type Error")
            return str
        }
        
        let newMetadata = FIRStorageMetadata()
        newMetadata.contentType = "image/jpeg"
        
        var path = ""
        switch type {
        case .postInsta:
            path = "/InstaPost/\(fileName).jpg"
            break
        case .profilePicture:
            path = "/ProfilePicture/\(currentUserUid()).jpg"
            break
        }
    
        var downloadURL : String?
        
        //upload image
        let frStorage = FIRStorage.storage().reference()
        frStorage.child(path).put(imageData, metadata: newMetadata, completion: {
            (storageMeta, error) in
            if let uploadError = error
            {
                print (uploadError)
                
                //this is to debug only
                assertionFailure("Failed to upload")    // dont do this on production
            }
            else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                downloadURL = storageMeta!.downloadURL()?.absoluteString
            }
        })
        
        guard let url = downloadURL
        else {
            return ""
        }
        return url
        
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
    
    func currentUserUid() -> String {
        guard let user = FIRAuth.auth()?.currentUser
        else{
            return ""
        }
        return user.uid
    }
    
    
    func getUserNameFromUid(uid : String) -> String{
        var name = ""
        frDBref.child("User/\(uid)/name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            name = value?["name"] as! String
            
        })
        return name
    }
    
    func modifyDatabase(path: String,key: String,value: String){
        frDBref.child("\(path)/\(key)").setValue(value)
    }
    
    func modifyDatabase(path: String,dictionary : [String : String] , autoId : Bool = false){
        if autoId{
            frDBref.child("\(path)/").childByAutoId().setValue(dictionary)
        }
        else{
            frDBref.child("\(path)/").setValue(dictionary)
        }
    }
    
    func deleteFromDatabase(path: String, item : String){
        frDBref.child("\(path)/").child(item).removeValue()
    }
    
    func prepareCommentDictionary(comment : String) -> [String : String]{
        var dict = [String : String]()
        dict["str"] = comment
        dict["postby"] = currentUserUid()
        dict["timestamp"] = String(Date().timeIntervalSince1970)
        
        return dict
    }
    
    func prepareProfileDictionary(name : String, desc : String, imageUrl : String) -> [String : String]{
        var dict = [String : String]()
        dict["name"] = name
        dict["desc"] = desc
        dict["picture"] = imageUrl
        
        return dict
    }
    
    func preparePostInstaDictionary(desc : String = "" , imageUrl : String) -> [String : String]{
        var dict = [String : String]()
        dict["desc"] = desc
        dict["url"] = imageUrl
        dict["poster"] = currentUserUid()
        dict["timestamp"] = String(Date().timeIntervalSince1970)
        
        return dict
    }
    
    func instagramActionPostInsta(desc : String = "", image :UIImage){
        //1. get auto id in ImagePost
        //2. upload to storage and get url
        //3. desc, url -> dict
        //4. upload database
        //         --post
        //         ImagePost/autoId +
        //         desc : str
        //         url : url
        //         poster : useruid
        //         timestamp : time
        //
        //        User/uid/posted/autoId + url
        
        //1
        let ref = frDBref.child("ImagePost").childByAutoId()
        ref.setValue("temp")
        let imageUid = ref.key

        //2. upload image with type postinsta and imagename = uid
        let url = uploadImageToStorageAndGetUrl(type: .postInsta, image: image, fileName: imageUid)
        
        //3. desc, url -> dict
        let dict = preparePostInstaDictionary(desc: desc, imageUrl: url)
        
        //4.
        ref.setValue(dict)
        let uid = currentUserUid()
        let path = "User/\(uid)/posted/"
        modifyDatabase(path: path, key: imageUid, value: url)
    }
    
    
    enum actionType {
        case removeInsta
        case like
        case unlike
        case comment
        case follow
        case unfollow
        case editProfile
    }
    
    func instagramAction( type : actionType, dict : [String : String] = [:], targetUid : String?){
        

        var path : String
        let userUid = currentUserUid()
        let username = getUserNameFromUid(uid: userUid)
        
        switch type {
            
        case .like :
            path = "ImagePost/\(targetUid)/likeby"
            self.modifyDatabase(path: path, key: userUid, value: username)
            break
            
        case .unlike :
            path = "ImagePost/\(targetUid)/likeby"
            self.deleteFromDatabase(path: path, item: userUid)
            break
            
        case .comment :
            path = "Comments/\(targetUid)"
            self.modifyDatabase(path: path, dictionary: dict, autoId: true)
            break
            
        case .follow :
            guard let target = targetUid
                else {
                break
            }
            let targetName = getUserNameFromUid(uid: target)
            path = "Following/\(userUid)/"
            self.modifyDatabase(path: path, key: target, value: targetName)
            path = "Follower/\(targetUid)"
            self.modifyDatabase(path: path, key: userUid, value: username)
            break
            
        case .unfollow :
            guard let target = targetUid
                else {
                    break
            }
            path = "Following/\(userUid)/"
            self.deleteFromDatabase(path: path, item: target)
            path = "Follower/\(targetUid)"
            self.deleteFromDatabase(path: path, item: userUid)
            break
            
        case .editProfile:
            path = "User/\(userUid)"
            self.modifyDatabase(path: path, key: "name", value: dict["name"]!)
            self.modifyDatabase(path: path, key: "desc", value: dict["desc"]!)
            self.modifyDatabase(path: path, key: "picture", value: dict["picture"]!)
            break
            
        case .removeInsta:
            guard let target = targetUid
                else {
                    break
            }
             path = "User/\(userUid)/posted"
             self.deleteFromDatabase(path: path, item: target)
            self.deleteFromDatabase(path: "Imagepost", item: target)
            self.deleteFromDatabase(path: "Comment", item: target)
            break
        }
        
//         --like
//         ImagePost/imageuid/likeby + currentUserUid
//         
//         --unlike
//         ImagePost/imageuid/likeby - currentUserUid
//         
//         --comment
//         Comments/imageuid + autoid +
//         str: str
//         postby : currentuUserUid
//         timestamp : time
//         ImagePost/imageuid/lastComment = autoid
//         
//         --follow
//         Following/currentUserUid + TargetUserUid
//         Follower/targetUserUid + currentUserUid
//         
//         --unfollow
//         Following/currentUserUid - TargetUserUid
//         Follower/targetUserUid - currentUserUid
//         
//         --edit profile
//         User/currentuserUid +
//         desc : desc
//         name : name
//         picture : url
//         
//         --removePost
//         User/currentUserUid/posted - imageUid
//         Imagepost - imageUid
//         Comment - imageUid
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

