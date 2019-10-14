//
//  FeedTableViewController.swift
//  Epicture
//
//  Created by Cecile on 14/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {

    //MARK: Properties
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSamplePhotos()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "FeedTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FeedTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PhotoTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let photo = photos[indexPath.row]
        
        cell.authorLabel.text = photo.author
        cell.photoImageView.image = photo.photo
        cell.commentLabel.text = photo.comment
        
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
        case "ShowDetail":
            guard let feedDetailViewController = segue.destination as? FeedPhotoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedFeedCell = sender as? FeedTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedFeedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
             
            let selectedPhoto = photos[indexPath.row]
            feedDetailViewController.photo = selectedPhoto
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    //MARK: Private Methods
    private func loadSamplePhotos() {
        
        let image1 = UIImage(named: "photo1")
        let image2 = UIImage(named: "photo2")
        let image3 = UIImage(named: "photo3")
        
        guard let photo1 = Photo(author: "Anais", photo: image1, comment: "Caprese Salad") else {
            fatalError("Unable to instantiate photo1")
        }
        
        guard let photo2 = Photo(author: "James", photo: image2, comment: "Chicken and Potatoes") else {
            fatalError("Unable to instantiate photo2")
        }
        
        guard let photo3 = Photo(author: "Emelia", photo: image3, comment: "Pasta with Meatballs") else {
            fatalError("Unable to instantiate photo2")
        }
        
        photos += [photo1, photo2, photo3]
    }

}
