//
//  FeedTableViewCell.swift
//  Epicture
//
//  Created by Cecile on 13/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var postID: String = ""
    var imageID: String? = nil
    var isFavorite: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    func updateHeart() {
        let favIds = loadAllFavoriteID()
    
        for id in favIds {
            if id == postID || (imageID != nil && id == imageID) {
                isFavorite = true
                favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = UIColor.red
                break
            }
        }
        if isFavorite == false {
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = UIColor.label
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Actions
    @IBAction func handleFavorite(_ sender: UIButton) {
        let client = ImgurAPIClient()
        if isFavorite {
            isFavorite = false
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = UIColor.label
            _ = try! client.manageThisFavorite(id: postID)
        } else {
            isFavorite = true
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = UIColor.red
            _ = try! client.manageThisFavorite(id: postID)
        }
        loadFavoriteFromImgur()
    }
    
}
