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
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
