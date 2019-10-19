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

    do {
        favoritePosts = try client.getFavorites(username: UserDefaults.standard.string(forKey: "account_username")!)
    } catch let err {
        print(err)
    }
}

func loadUserFeedFromImgur() {
    let client = ImgurAPIClient()

    do {
        userPosts = try client.getFavorites(username: UserDefaults.standard.string(forKey: "account_username")!)
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
