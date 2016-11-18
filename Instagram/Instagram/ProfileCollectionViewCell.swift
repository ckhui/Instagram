//
//  ProfileCollectionViewCell.swift
//  Swiftgram
//
//  Created by NEXTAcademy on 11/15/16.
//  Copyright © 2016 NEXTAcademy. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var profileFullName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var numberOfPosts: UILabel!
    
    @IBOutlet weak var numberOfFollowers: UILabel!
    {
        didSet{
            numberOfFollowers.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.onFollowerLabelPressed(sender:)))
            numberOfFollowers.addGestureRecognizer(tap)
        }
    }
    
    
    @IBOutlet weak var numberOfFollowing: UILabel!
    {
        didSet{
            numberOfFollowing.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.onFollowingLabelPressed(sender:)))
            numberOfFollowing.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var editProfileOnLabelPressed: UILabel!
    {
        didSet{
            editProfileOnLabelPressed.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.onEditLabelPressed(sender:)))
            editProfileOnLabelPressed.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var viewContainingButtons: UIView!
    
    var delegate : ProfileCollectionViewCellDelegate?
    
    func onFollowerLabelPressed(sender: UITapGestureRecognizer){
        delegate?.profileCellOnFollowerLabelPressed(cell: self)
    }
    
    func onFollowingLabelPressed(sender: UITapGestureRecognizer){
        delegate?.profileCellOnFollowingLabelPressed(cell: self)
    }
    
    func onEditLabelPressed(sender: UITapGestureRecognizer){
        delegate?.profileCellOnEditLabelPressed(cell: self)
    }
}

protocol ProfileCollectionViewCellDelegate {
    func profileCellOnFollowerLabelPressed(cell : ProfileCollectionViewCell)
    func profileCellOnFollowingLabelPressed(cell : ProfileCollectionViewCell)
    func profileCellOnEditLabelPressed(cell : ProfileCollectionViewCell)
}

