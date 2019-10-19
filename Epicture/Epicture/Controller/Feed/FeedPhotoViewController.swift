//
//  FeedPhotoViewController.swift
//  Epicture
//
//  Created by Cecile on 11/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit
import AVKit

class FeedPhotoViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var post: Post?
    var isFavorite: Bool = false
    
    var image: UIImage?
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let post = post else {
            return
        }
        navigationItem.title = post.image.title
        titleLabel.text = post.image.title
        commentLabel.text = post.image.description
    
        DispatchQueue.global(qos: .userInteractive).async {
            guard let type = post.image.type else {
                print("[MyFeedPhoto] - Empty image type")
                return
            }
            if type.contains("image/jpg") || type.contains("image/jpeg") {
                guard let image = self.image else {
                    print("[MyFeedPhoto] - A problem occured on image transfert")
                    return
                }
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = UIView.ContentMode.scaleAspectFit
                    imageView.frame = self.postView.bounds
                    self.postView.addSubview(imageView)
                }
            } else if type.contains("/mp4") || type.contains("/avi") {
                guard let player = self.player else {
                    print("[MyFeedPhoto] - A problem occured on video transfert")
                    return
                }
                DispatchQueue.main.async {
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = self.postView.bounds
                    playerLayer.videoGravity = AVLayerVideoGravity.resize
                    self.postView.layer.addSublayer(playerLayer)
                    player.play()
                }
            }
        }

    }

    //MARK: Actions
    @IBAction func addToFavorite(_ sender: UIButton) {
        //MARK: TODO Add to Favorites
        if isFavorite {
            isFavorite = false
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = UIColor.label
        } else {
            isFavorite = true
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
