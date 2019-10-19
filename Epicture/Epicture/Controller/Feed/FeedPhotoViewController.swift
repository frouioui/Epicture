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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let post = post else {
            return
        }
        navigationItem.title = post.image.title
        titleLabel.text = post.image.title
        commentLabel.text = post.image.description
        DispatchQueue.global(qos: .background).async {
            guard let link = post.image.link else {
                print("Favorites - A problem occured with post image link")
                return
            }
            guard let url = URL(string: link) else {
                print("Favorites - A problem occured on url conversion")
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                print("Favorites - A problem occured on data conversion")
                return
            }
            if post.image.type!.contains("image/jpg") || post.image.type!.contains("image/jpeg") {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = UIView.ContentMode.scaleAspectFit
                        imageView.frame = self.postView.bounds
                        self.postView.addSubview(imageView)
                    }
                }
            } else if post.image.type!.contains("/mp4") || post.image.type!.contains("/avi") {
                DispatchQueue.main.async {
                    let player = AVPlayer(url: url)
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
//        guard let photo = photo else {
//            return
//        }
//        if photo.favorite {
//            photo.favorite = false
//            favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
//            favoriteButton.tintColor = UIColor.label
//        } else {
//            photo.favorite = true
//            favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
//            favoriteButton.tintColor = UIColor.red
//        }
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
