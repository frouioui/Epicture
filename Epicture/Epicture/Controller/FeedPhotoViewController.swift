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

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let photo = photo {
            navigationItem.title = photo.author
            authorLabel.text = photo.author
            commentLabel.text = photo.comment
            photoImageView.image = photo.photo
        }
    }

    //MARK: Actions
    @IBAction func addPhotoToFavorites(_ sender: UITapGestureRecognizer) {
        //MARK: TODO Add to Favorites if double tap
    }
    
    @IBAction func addToFavorite(_ sender: UIButton) {
        //MARK: TODO Add to Favorites
    }

    
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        if let owningNavigationController = navigationController {
//            owningNavigationController.popViewController(animated: true)
//        }
//        dismiss(animated: true, completion: nil)
//    }
//    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
