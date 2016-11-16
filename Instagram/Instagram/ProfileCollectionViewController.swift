//
//  ProfileCollectionViewController.swift
//  Swiftgram
//
//  Created by NEXTAcademy on 11/15/16.
//  Copyright © 2016 NEXTAcademy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "profileCell"

class ProfileCollectionViewController: UICollectionViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add tap gesture to edit profiel
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

       

    }



    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
    
        // insert number of post followers etc here
        cell.numberOfPosts.text = "23"
        cell.numberOfFollowing.text = "343"
        cell.numberOfFollowers.text = "543"
        
        
        //fonts layout
        cell.numberOfPosts.font = UIFont.boldSystemFont(ofSize: 16)
        cell.numberOfFollowers.font = UIFont.boldSystemFont(ofSize: 16)
        cell.numberOfFollowing.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        //circular profile picture
        cell.profilePicture.image = #imageLiteral(resourceName: "pichu")
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height / 2
        cell.profilePicture.clipsToBounds = true
        cell.profilePicture.layer.borderWidth = 1.0
        cell.profilePicture.layer.masksToBounds = false
        

        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

   

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

   
}
