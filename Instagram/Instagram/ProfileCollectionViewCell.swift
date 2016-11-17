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
    @IBOutlet weak var numberOfFollowing: UILabel!
    @IBOutlet weak var editProfileOnLabelPressed: UILabel!
    @IBOutlet weak var viewContainingButtons: UIView!
}
