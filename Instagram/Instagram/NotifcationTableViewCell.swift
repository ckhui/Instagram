//
//  NotifcationTableViewCell.swift
//  Swiftgram
//
//  Created by NEXTAcademy on 11/15/16.
//  Copyright © 2016 NEXTAcademy. All rights reserved.
//

import UIKit

class NotifcationTableViewCell: UITableViewCell {
    @IBOutlet weak var friendsIconImage: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
