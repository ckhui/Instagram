//
//  Insta.swift
//  Instagram
//
//  Created by ALLAN CHAI on 16/11/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import Foundation

class Insta {
    var imageUid : String? = nil
    var posterID : String? = nil
    var postImageURL : String? = nil
    var postDetail : String? = nil
    var postTime : String? = nil
    
    //had the current user ald like?
    var isLiked : Bool = false
    // TODO : save liker name
    var like : [String] = []
    var comment : Int = 0
    var username : String? = nil
    var profilePictureURL : String? = nil
}
