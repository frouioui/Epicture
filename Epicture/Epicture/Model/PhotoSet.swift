//
//  PhotoSet.swift
//  Epicture
//
//  Created by Cecile on 16/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class PhotoView {
    
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
}
