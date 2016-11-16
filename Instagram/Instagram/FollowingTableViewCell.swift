//
//  FollowingTableViewCell.swift
//  Swiftgram
//
//  Created by NEXTAcademy on 11/15/16.
//  Copyright © 2016 NEXTAcademy. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionViewOnUserLikedPictures: UICollectionView!
    @IBOutlet weak var descriptionOnWhatUserLikes: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
