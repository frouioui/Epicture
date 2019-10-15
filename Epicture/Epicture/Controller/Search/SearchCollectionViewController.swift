//
//  SearchCollectionViewController.swift
//  Epicture
//
//  Created by Cecile on 13/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "Cell"

extension SearchCollectionViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

class SearchCollectionViewController: UICollectionViewController {
    
    //MARK: Properties
    var photos = [Photo]()
    var filteredPhotos: [Photo] = []

    let searchController = UISearchController(searchResultsController: nil)

    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        loadPhoto()

        // Add Search Controller in Navigation Bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
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

                let selectedPhoto: Photo

                if isFiltering {
                    selectedPhoto = filteredPhotos[indexPath.row]
                } else {
                    selectedPhoto = photos[indexPath.row]
                }
                searchDetailViewController.photo = selectedPhoto

            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPhotos.count
        }
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "SearchCollectionViewCell"

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? SearchCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of SearchCollectionViewCell.")
        }
        // Fetches the appropriate photo for the data source layout.
        let photo: Photo
        if isFiltering {
            photo = filteredPhotos[indexPath.row]
        } else {
            photo = photos[indexPath.row]
        }

        cell.photoImageView.image = photo.photo

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
     Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

    }
    */
    //MARK: Privates Methods
    private func loadPhoto() {
        //MARK: TODO load photo from Imgur
        let image1 = UIImage(named: "photo1")
        let image2 = UIImage(named: "photo2")
        let image3 = UIImage(named: "photo3")

        guard let photo1 = Photo(author: "Anais", photo: image1, title: "Caprese Salad", comment: "blablabla", favorite: true) else {
            fatalError("Unable to instantiate photo1")
        }

        guard let photo2 = Photo(author: "James", photo: image2, title: "Chicken and Potatoes", comment: "blabla") else {
            fatalError("Unable to instantiate photo2")
        }

        guard let photo3 = Photo(author: "Emelia", photo: image3, title: "Pasta with Meatballs", comment: "blablabla") else {
            fatalError("Unable to instantiate photo3")
        }

        photos += [photo1, photo2, photo3]
    }

    private func filterContentForSearchText(_ searchText: String) {
      filteredPhotos = photos.filter { (photo: Photo) -> Bool in
        return photo.title.lowercased().contains(searchText.lowercased())
      }
      
        collectionView.reloadData()
    }
}
