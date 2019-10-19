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
    var posts = [Post]()
    var filteredPosts: [Post] = []

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
        posts = userPosts

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
        
        DispatchQueue.global(qos: .background).async {
            guard let link = post.image.link else {
                print("MyFeed - A problem occured with post image link")
                return
            }
            guard let url = URL(string: link) else {
                print("MyFeed - A problem occured on url conversion")
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                print("MyFeed - A problem occured on data conversion")
                return
            }
            if post.image.type!.contains("image/jpg") || post.image.type!.contains("image/jpeg") {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: image)
                        imageView.contentMode = UIView.ContentMode.scaleAspectFit
                        imageView.frame = cell.postView.bounds
                        cell.postView.addSubview(imageView)
                    }
                }
            } else if post.image.type!.contains("/mp4") || post.image.type!.contains("/avi") {
                DispatchQueue.main.async {
                    let player = AVPlayer(url: url)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = cell.postView.bounds
                    playerLayer.videoGravity = AVLayerVideoGravity.resize
                    cell.postView.layer.addSublayer(playerLayer)
                    player.play()
                }
            }
        }
//        if photo.favorite {
//            cell.favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
//            cell.favoriteButton.tintColor = UIColor.red
//        } else {
//            cell.favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
//            cell.favoriteButton.tintColor = UIColor.label
//        }
        tableView.reloadData()
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
                selectedPost = posts[indexPath.row]
            }
            feedDetailViewController.post = selectedPost
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    //MARK: Private Methods
//    private func loadSamplePhotos() {
//
//        let image1 = UIImage(named: "photo1")
//        let image2 = UIImage(named: "photo2")
//        let image3 = UIImage(named: "photo3")
//
//        guard let photo1 = Photo(author: "Anais", photo: image1, title: "Caprese Salad", comment: "blablabla", favorite: true) else {
//            fatalError("Unable to instantiate photo1")
//        }
//
//        guard let photo2 = Photo(author: "James", photo: image2, title: "Chicken and Potatoes", comment: "blabla") else {
//            fatalError("Unable to instantiate photo2")
//        }
//
//        guard let photo3 = Photo(author: "Emelia", photo: image3, title: "Pasta with Meatballs", comment: "blablabla") else {
//            fatalError("Unable to instantiate photo3")
//        }
//
//        photos += [photo1, photo2, photo3]
//    }

    private func filterContentForSearchText(_ searchText: String) {
      filteredPosts = posts.filter { (posts: Post) -> Bool in
        return (posts.image.title?.lowercased().contains(searchText.lowercased()) ?? false)
      }
      
      tableView.reloadData()
    }
}
