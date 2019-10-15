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
    var title: String
    var photo: UIImage?
    var comment: String
    var favorite: Bool
    
    //MARK: Initialization
    
    init?(author: String, photo: UIImage?, title: String, comment: String, favorite: Bool = false) {

        if author.isEmpty || title.isEmpty || comment.isEmpty {
            return nil
        }

        self.author = author
        self.title = title
        self.photo = photo
        self.comment = comment
        self.favorite = favorite
    }
}

