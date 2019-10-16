//
//  FeedPhotoViewController.swift
//  Epicture
//
//  Created by Cecile on 11/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class FeedPhotoViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let photo = photo else {
            return
        }
        navigationItem.title = photo.title
        titleLabel.text = photo.title
        commentLabel.text = photo.comment
        photoImageView.image = photo.photo
        if photo.favorite {
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = UIColor.red
        }
    }

    //MARK: Actions
    @IBAction func addToFavorite(_ sender: UIButton) {
        //MARK: TODO Add to Favorites
        guard let photo = photo else {
            return
        }
        if photo.favorite {
            photo.favorite = false
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = UIColor.label
        } else {
            photo.favorite = true
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            favoriteButton.tintColor = UIColor.red
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
