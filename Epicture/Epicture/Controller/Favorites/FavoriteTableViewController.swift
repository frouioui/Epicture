//
//  FavoriteTableViewController.swift
//  Epicture
//
//  Created by Cecile on 15/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

extension FavoriteTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

class FavoriteTableViewController: UITableViewController {

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

        // Load the sample data.
        loadSamplePhotos()

        // Add Search Controller in Navigation Bar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filteredPhotos.count
        }
        return photos.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FavoriteTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavoriteTableViewCell  else {
            fatalError("The dequeued cell is not an instance of FavoriteTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let photo: Photo
        if isFiltering {
            photo = filteredPhotos[indexPath.row]
        } else {
            photo = photos[indexPath.row]
        }
        
        cell.authorLabel.text = photo.author
        cell.titleLabel.text = photo.title
        cell.photoImageView.image = photo.photo
        cell.commentLabel.text = photo.comment
        if photo.favorite {
            cell.favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.favoriteButton.tintColor = UIColor.red
        } else {
            cell.favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            cell.favoriteButton.tintColor = UIColor.label
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "FavoriteShowDetail":
            guard let favoriteDetailViewController = segue.destination as? FavoritePhotoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedFeedCell = sender as? FavoriteTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedFeedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedPhoto: Photo

            if isFiltering {
                selectedPhoto = filteredPhotos[indexPath.row]
            } else {
                selectedPhoto = photos[indexPath.row]
            }
            favoriteDetailViewController.photo = selectedPhoto
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    //MARK: Private Methods
    private func loadSamplePhotos() {
        
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
      
      tableView.reloadData()
    }
}
