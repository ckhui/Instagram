//
//  ProfileCollectionViewController.swift
//  Swiftgram
//
//  Created by NEXTAcademy on 11/15/16.
//  Copyright © 2016 NEXTAcademy. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "profileCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
private let itemsPerRow: CGFloat = 3

class ProfileCollectionViewController: UICollectionViewController{
    var users = User()
    var arrayOfPicturesUrl = [String]()
    var arrayOfFollowers = [String]()
    var arrayOfFollowings = [String]()
    var labelIsTapped = false
    
    var userUID = Instagram().currentUserUid()
    
    var profilelUid : String?
    
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        // TODO : if other user, display back button, not allow eidt profil...        
        if let uid = profilelUid{
            userUID = uid
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUser()
        fetchFollowers()
        fetchFollowings()
    }
    
    //MARK: - fetch data
    func fetchUser() {
        ref.child("User").child(userUID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.users.desc = (dictionary["desc"] as! String?)!
                self.users.name = (dictionary["name"] as! String?)!
                self.users.picture = (dictionary["picture"] as! String?)!
                if dictionary.index(forKey: "posted") != nil {
                    self.users.posted = (dictionary["posted"] as! [String : String]?)!
                }
                
                let imageurlArray = self.users.posted
                for imageurl in imageurlArray {
                    
                    self.arrayOfPicturesUrl.append(imageurl.value)
                    print(imageurl.value)
                    print((String)(self.arrayOfPicturesUrl.count))
                    
                    
                }
                self.collectionView?.reloadData()
            }
            
        })
    }
    
    func fetchFollowers() {
        ref.child("Follower").child(userUID).observe(.value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print(dictionary.keys)
                self.arrayOfFollowers = []

                for key in dictionary.keys {
                    self.arrayOfFollowers.append(key)
                }
                self.collectionView?.reloadData()
            }
        })
    }
    
    func fetchFollowings() {
        ref.child("Following").child(userUID).observe(.value, with: {(snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print(dictionary.keys)
                self.arrayOfFollowings = []

                for key in dictionary.keys {
                    self.arrayOfFollowings.append(key)
                }
                self.collectionView?.reloadData()
            }
        })
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.users.posted.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
            
            // insert number of post followers etc here
            cell.numberOfPosts.text = (String)(self.users.posted.count)
            cell.numberOfFollowing.text = (String)(self.arrayOfFollowings.count)
            cell.numberOfFollowers.text = (String)(self.arrayOfFollowers.count)
            cell.profileFullName.text = self.users.name
            cell.profileDescription.text = self.users.desc
            
            //fonts layout
            cell.numberOfPosts.font = UIFont.boldSystemFont(ofSize: 16)
            cell.numberOfFollowers.font = UIFont.boldSystemFont(ofSize: 16)
            cell.numberOfFollowing.font = UIFont.boldSystemFont(ofSize: 16)
            
    
            if self.users.picture != "" {
                cell.profilePicture.loadImageUsingCacheWithUrlString(self.users.picture)
               cell.profilePicture.roundShape()
            }
            cell.delegate = self
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! GridLayoutCollectionViewCell
            var url = ""
            
            if self.arrayOfPicturesUrl.count > 0 {
                url = self.arrayOfPicturesUrl[indexPath.row - 1]
                cell.profileImages.loadImageUsingCacheWithUrlString(url)
                cell.profileImages.centerSquare()
            
            }
            return cell
        }
    }
    
}

//MARK: - modify cell layout
extension ProfileCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if indexPath.row != 0 {
            //2
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem)
        } else{
            
            
            //make it dynamic
            return CGSize(width: 375, height: 260)
            
        }
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

// MARK: UICollectionViewDelegate

/*
 // Uncomment this method to specify if the specified item should be selected
 override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
 return true
 }
 */


extension ProfileCollectionViewController : ProfileCollectionViewCellDelegate{
    func profileCellOnEditLabelPressed(cell: ProfileCollectionViewCell) {
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    
    func profileCellOnFollowerLabelPressed(cell: ProfileCollectionViewCell) {
        performSegue(withIdentifier: "showFollower", sender: self)
    }
    
    func profileCellOnFollowingLabelPressed(cell: ProfileCollectionViewCell) {
        performSegue(withIdentifier: "showFollowing", sender: self)
    }
}

extension ProfileCollectionViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFollower") {
            let destination = segue.destination as! FollowerListViewController
            destination.uidArray = arrayOfFollowers
            return
        }
        else if (segue.identifier == "showFollowing") {
            let destination = segue.destination as! FollowerListViewController
            destination.uidArray = arrayOfFollowings
            return
        }
        else if (segue.identifier == "editProfileSegue") {
            return
        }
        
        
        
        
        
    }
}

