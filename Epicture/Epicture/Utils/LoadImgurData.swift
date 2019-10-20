//
//  LoadImgurData.swift
//  Epicture
//
//  Created by Cecile on 17/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

func loadFavoriteFromImgur() {
    let client = ImgurAPIClient()

    guard let username = UserDefaults.standard.string(forKey: "account_username") else {
        print("[loadFavoriteFromImgur] - Empty username")
        return
    }
    do {
        favoritePosts = try client.getFavorites(username: username)
    } catch let err {
        print(err)
    }
}

func loadUserFeedFromImgur() {
    let client = ImgurAPIClient()

    guard let username = UserDefaults.standard.string(forKey: "account_username") else {
        print("[loadUserFeedFromImgur] - Empty username")
        return
    }
    do {
        userPosts = try client.getUserImage(username: username)
    } catch let err {
        print(err)
    }
}

func loadImageFromUrl(link: String) -> UIImage {
    var image = UIImage()

    if let url = URL(string: link) {
        if let data = try? Data(contentsOf: url) {
            image = UIImage(data: data)!
        }
    }
    return image
}

func loadAllFavoriteID() -> [String] {
    let client = ImgurAPIClient()
    var ids: [String] = []
    
    guard let username = UserDefaults.standard.string(forKey: "account_username") else {
        print("[loadUserFeedFromImgur] - Empty username")
        return ids
    }
    do {
        ids = try client.getFavoritesID(username: username)
    } catch let err {
        print(err)
    }
    return ids
}
