//
//  SearchCollectionViewController.swift
//  Epicture
//
//  Created by Cecile on 13/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit
import AVKit
import os.log

private let reuseIdentifier = "Cell"

class SearchCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    //MARK: Properties
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var posts: [Post] = []
    var filteredPosts: [Post] = []
    
    var keywords: [String] = []
    
    var imageView: UIImageView?
    var image: UIImage?
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?

    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    var isFiltering: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPosts.count
        }
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "SearchCollectionViewCell"

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SearchCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchCollectionViewCell.")
        }
        // Fetches the appropriate photo for the data source layout.
        let post: Post
        if isFiltering {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }

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

    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        switch(segue.identifier ?? "") {
            case "SearchShowDetail":
                guard let searchDetailViewController = segue.destination as? SearchPhotoViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }

                guard let selectedPhotoCell = sender as? SearchCollectionViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }

                guard let indexPath = collectionView.indexPath(for: selectedPhotoCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }

                let selectedPost: Post

                if isFiltering || isSearching {
                    selectedPost = filteredPosts[indexPath.row]
                } else {
                    selectedPost = posts[indexPath.row]
                }
                searchDetailViewController.post = selectedPost
                searchDetailViewController.image = self.image
                searchDetailViewController.player = self.player

            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    //MARK:Action
    @IBAction func filterContent(_ sender: UISegmentedControl) {
        switch self.segmentControl.selectedSegmentIndex {
            case 0:
                function(keywords: self.keywords, sort: .year)
                self.isFiltering = true
            case 1:
                function(keywords: self.keywords, sort: .month)
                self.isFiltering = true
            case 2:
                function(keywords: self.keywords, sort: .week)
                self.isFiltering = true
            case 3:
                function(keywords: self.keywords, sort: .day)
                self.isFiltering = true
            default:
                function(keywords: self.keywords, sort: .all)
                self.isFiltering = true
        }
        self.collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        if !self.keywords.isEmpty {
            self.keywords.removeAll()
        }
        self.keywords = searchText.components(separatedBy: " ")
        
        switch self.segmentControl.selectedSegmentIndex {
            case 0:
                function(keywords: self.keywords, sort: .year)
                self.isFiltering = true
            case 1:
                function(keywords: self.keywords, sort: .month)
                self.isFiltering = true
            case 2:
                function(keywords: self.keywords, sort: .week)
                self.isFiltering = true
            case 3:
                function(keywords: self.keywords, sort: .day)
                self.isFiltering = true
            default:
                function(keywords: self.keywords, sort: .all)
                self.isFiltering = true
        }
        searchBar.resignFirstResponder()
        self.collectionView?.reloadData()
    }

    private func function(keywords: [String], sort: ImgurAPIClient.SortSearch) {
        let client = ImgurAPIClient()
        
        guard let username = UserDefaults.standard.string(forKey: "account_username") else {
            print("[loadUserFeedFromImgur] - Empty username")
            return
        }
        do {
            self.filteredPosts = try client.getSearchResult(username: username, keywords: keywords, sort: sort)
        } catch let err {
            print(err)
        }
    }
}
