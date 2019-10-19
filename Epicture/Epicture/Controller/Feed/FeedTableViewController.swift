//
//  FeedTableViewController.swift
//  Epicture
//
//  Created by Cecile on 14/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit
import AVKit

extension FeedTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

var userPosts: [Post] = []

class FeedTableViewController: UITableViewController {

    //MARK: Properties
//    var posts = [Post]()
    var filteredPosts: [Post] = []

    var imageView: UIImageView?
    var image: UIImage?
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?

    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Asign user posts
//        posts = userPosts

        // Add Search Controller in Navigation Bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPosts.count
        }
        return userPosts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FeedTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FeedTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PhotoTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let post: Post
        if isFiltering {
            post = filteredPosts[indexPath.row]
        } else {
            post = userPosts[indexPath.row]
        }
        
        cell.titleLabel.text = post.image.title
        cell.commentLabel.text = post.image.description

        DispatchQueue.global(qos: .userInteractive).async {
            guard let link = post.image.link else {
                print("[MyFeed] - A problem occured with post image link")
                return
            }
            guard let url = URL(string: link) else {
                print("[MyFeed] - A problem occured on url conversion")
                return
            }
            guard let type = post.image.type else {
                print("[MyFedd] - Empty image type")
                return
            }
            if type.contains("image/jpg") || type.contains("image/jpeg") {
                guard let data = try? Data(contentsOf: url) else {
                    print("[MyFeed] - A problem occured on data conversion")
                    return
                }
                self.image = UIImage(data: data)
                if self.image == nil {
                    print("[MyFeed] - A problem occured on image loading")
                    return
                }
                DispatchQueue.main.async {
                    if self.imageView != nil {
                        self.imageView?.removeFromSuperview()
                    }
                    self.imageView = UIImageView(image: self.image)
                    guard let imageView = self.imageView else {
                        print("[MyFeed] - A problem occured on imageView loading")
                        return
                    }
                    imageView.contentMode = UIView.ContentMode.scaleAspectFit
                    imageView.frame = cell.postView.bounds
                    cell.postView.addSubview(self.imageView!)
                }
            } else if type.contains("/mp4") || type.contains("/avi") {
                DispatchQueue.main.async {
                    self.player = AVPlayer(url: url)
                    guard let player = self.player else {
                        print("[MyFeed] - A problem occured on video loading")
                        return
                    }
                    self.playerLayer = AVPlayerLayer(player: player)
                    guard let playerLayer = self.playerLayer else {
                        print("[MyFeed] - A problem occured on playerlayer loading")
                        return
                    }
                    playerLayer.frame = cell.postView.bounds
                    playerLayer.videoGravity = AVLayerVideoGravity.resize
                    cell.postView.layer.addSublayer(playerLayer)
                    player.play()
                }
            }
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "FeedShowDetail":
            guard let feedDetailViewController = segue.destination as? FeedPhotoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedFeedCell = sender as? FeedTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedFeedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedPost: Post

            if isFiltering {
                selectedPost = filteredPosts[indexPath.row]
            } else {
                selectedPost = userPosts[indexPath.row]
            }
            feedDetailViewController.post = selectedPost
            feedDetailViewController.image = self.image
            feedDetailViewController.player = self.player
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    //MARK: Private Methods
    private func filterContentForSearchText(_ searchText: String) {
      filteredPosts = userPosts.filter { (posts: Post) -> Bool in
        return (posts.image.title?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      
      tableView.reloadData()
    }
}
