//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by ALLAN CHAI on 15/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
