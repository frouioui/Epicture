//
//  PhotoCollectionViewController.swift
//  Epicture
//
//  Created by Cecile on 13/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController {
    //MARK: Properties
    
    var photos = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self as? UISearchResultsUpdating
        self.navigationItem.searchController = search
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
//        loadPhoto()
    }


    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//
//        switch(segue.identifier ?? "") {
//            case "ShowDetail":
////                guard let photoDetailViewController = segue.destination as? PhotoViewController else {
////                    fatalError("Unexpected destination: \(segue.destination)")
////                }
//
//                guard let selectedPhotoCell = sender as? PhotoCollectionViewCell else {
//                    fatalError("Unexpected sender: \(String(describing: sender))")
//                }
//
//                guard let indexPath = collectionView.indexPath(for: selectedPhotoCell) else {
//                    fatalError("The selected cell is not being displayed by the table")
//                }
//
//                let selectedPhoto = photos[indexPath.row]
//                photoDetailViewController.photo = selectedPhoto
//
//            default:
//                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
//        }
        
    }


    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return photos.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cellIdentifier = "PhotoCollectionViewCell"
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell  else {
//            fatalError("The dequeued cell is not an instance of PhotoCollectionViewCell.")
//        }
//        // Fetches the appropriate photo for the data source layout.
//        let photo = photos[indexPath.row]
//
//        cell.photoImageView.image = photo.photo
//
//        return cell
//    }

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
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
//    */
//    //MARK: Privates Methods
//    private func loadPhoto() {
//        //MARK: TODO load photo from Imgur
//        let image1 = UIImage(named: "photo1")
//        let image2 = UIImage(named: "photo2")
//        let image3 = UIImage(named: "photo3")
//
//        guard let photo1 = Photo(title: "Caprese Salad", photo: image1, comment: "Just enough") else {
//            fatalError("Unable to instantiate photo1")
//        }
//
//        guard let photo2 = Photo(title: "Chicken and Potatoes", photo: image2, comment: "Just enough") else {
//            fatalError("Unable to instantiate meal2")
//        }
//
//        guard let photo3 = Photo(title: "Pasta with Meatballs", photo: image3, comment: "Just enough") else {
//            fatalError("Unable to instantiate meal2")
//        }
//
//        photos += [photo1, photo2, photo3]
//    }
//
//}
