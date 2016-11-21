//
//  SearchTableViewCell.swift
//  Instagram
//
//  Created by ALLAN CHAI on 16/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
 
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var backgroundCardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    func updateUI() {
        backgroundCardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
    }
    
    
}
