//
//  Photo.swift
//  Epicture
//
//  Created by Cecile on 11/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class Photo {
    
    //MARK:Properties
    var author: String
    var photo: UIImage?
    var comment: String
    var favorite: Bool
    
    //MARK: Initialization
    
    init?(author: String, photo: UIImage?, comment: String, favorite: Bool = false) {

        if author.isEmpty || comment.isEmpty {
            return nil
        }

        self.author = author
        self.photo = photo
        self.comment = comment
        self.favorite = favorite
    }
}

