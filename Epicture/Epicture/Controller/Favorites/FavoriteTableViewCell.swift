//
//  FavoriteTableViewCell.swift
//  Epicture
//
//  Created by Cecile on 15/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postView: UIView!
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
