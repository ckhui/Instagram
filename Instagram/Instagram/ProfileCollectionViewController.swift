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
    let tapGesture = UITapGestureRecognizer()
    var labelIsTapped = false
    var userUID = "Admin1"
    
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        //add tap gesture to edit profile
        tapGesture.addTarget(self, action: #selector(handleTap))
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
                self.users.posted = (dictionary["posted"] as! [String : String]?)!
                
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
            
            
            //edit profile
            cell.editProfileOnLabelPressed.addGestureRecognizer(tapGesture)
            cell.editProfileOnLabelPressed.isUserInteractionEnabled = true
            cell.editProfileOnLabelPressed.highlightedTextColor = UIColor.red
            if labelIsTapped {
                cell.editProfileOnLabelPressed.isHighlighted = true
            } else {
                cell.editProfileOnLabelPressed.isHighlighted = false
            }
            
            //       view layout
            //        cell.viewContainingButtons.layer.borderWidth = 0.5
            //        let grayColor = UIColor(red: 128/255, green: 128/255 , blue: 128/255 , alpha: 1)
            //        cell.viewContainingButtons.layer.borderColor = grayColor.cgColor
            
            
            
            //circular profile picture
            if self.users.picture != "" {
                //cell.profilePicture.loadImageUsingCacheWithUrlString(self.users.picture)
                let imgdata = NSData(contentsOf: NSURL(string: self.users.picture)! as URL)
                let img = UIImage(data: imgdata as! Data)
                cell.profilePicture.image = img
                
                cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height / 2
                cell.profilePicture.clipsToBounds = true
                cell.profilePicture.layer.borderWidth = 1.0
                cell.profilePicture.layer.masksToBounds = true
                cell.profilePicture.contentMode = .scaleAspectFill
            }
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! GridLayoutCollectionViewCell
            var url = ""
            
            if self.arrayOfPicturesUrl.count > 0 {
                url = self.arrayOfPicturesUrl[indexPath.row - 1]
                print("********** \(url)")
                //cell.profileImages.loadImageUsingCacheWithUrlString(url)
                let imgdata = NSData(contentsOf: NSURL(string: url)! as URL)
                let img = UIImage(data: imgdata as! Data)
                cell.profileImages.image = img
                
            }
            return cell
        }
    }
    
    
    
    //MARK: - label tap to edit function
    func handleTap() {
        print("tapped fool")
        if labelIsTapped {
            labelIsTapped = false
            self.collectionView?.reloadData()
        } else {
            labelIsTapped = true
            self.collectionView?.reloadData()
            
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

