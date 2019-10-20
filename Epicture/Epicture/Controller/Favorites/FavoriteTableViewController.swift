//
//  FavoriteTableViewController.swift
//  Epicture
//
//  Created by Cecile on 15/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit
import AVKit

extension FavoriteTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

var favoritePosts: [Post] = []

class FavoriteTableViewController: UITableViewController {

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

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Add Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPosts.count
        }
        return favoritePosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("toto")
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FavoriteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FavoriteTableViewCell.")
        }
        
        // Fetches the appropriate photo for the data source layout.
        let post: Post
        if isFiltering {
            post = filteredPosts[indexPath.row]
        } else {
            post = favoritePosts[indexPath.row]
        }

        cell.authorLabel.text = post.image.account_url
        cell.titleLabel.text = post.image.title
        cell.commentLabel.text = post.image.description
        cell.postID = post.postID
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard let link = post.image.link else {
                print("[Favorites] - A problem occured with post image link")
                return
            }
            guard let url = URL(string: link) else {
                print("[Favorites] - A problem occured on url conversion")
                return
            }
            guard let type = post.image.type else {
                print("[Favorites] - Empty image type")
                return
            }
            if type.contains("image/jpg") || type.contains("image/jpeg") {
                guard let data = try? Data(contentsOf: url) else {
                    print("[Favorites] - A problem occured on data conversion")
                    return
                }
                self.image = UIImage(data: data)
                if self.image == nil {
                    print("[Favorites] - A problem occured on image loading")
                    return
                }
                DispatchQueue.main.async {
                    if self.imageView != nil {
                        self.imageView?.removeFromSuperview()
                    }
                    self.imageView = UIImageView(image: self.image)
                    guard let imageView = self.imageView else {
                        print("[Favorites] - A problem occured on imageView loading")
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
                        print("[Favorites] - A problem occured on video loading")
                        return
                    }
                    self.playerLayer = AVPlayerLayer(player: player)
                    guard let playerLayer = self.playerLayer else {
                        print("[Favorites] - A problem occured on playerlayer loading")
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
        case "FavoriteShowDetail":
            guard let favoriteDetailViewController = segue.destination as? FavoritePhotoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedFavoriteCell = sender as? FavoriteTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedFavoriteCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedPost: Post

            if isFiltering {
                selectedPost = filteredPosts[indexPath.row]
            } else {
                selectedPost = favoritePosts[indexPath.row]
            }
            favoriteDetailViewController.post = selectedPost
            favoriteDetailViewController.image = self.image
            favoriteDetailViewController.player = self.player
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Private Methods
    private func filterContentForSearchText(_ searchText: String) {
      filteredPosts = favoritePosts.filter { (posts: Post) -> Bool in
        return (posts.image.title?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      
      tableView.reloadData()
    }
}
