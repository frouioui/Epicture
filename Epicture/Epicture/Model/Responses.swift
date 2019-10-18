//
//  Responses.swift
//  Epicture
//
//  Created by Cecile on 08/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import Foundation

struct User: Codable {
    
}



//MARK: Image
struct Image: Codable {
    init() {
        id = ""
        title = ""
        description = ""
        type = ""
        account_url = ""
        account_id = -1
        views = -1
        link = ""
    }
    var id: String?
    var title: String?
    var description: String?
    var type: String?
    var account_url: String?
    var account_id: Int?
    var views: Int?
    var link: String?
}

struct MultipleImagesResponse: Codable {
    var data: [Image]
}

struct ImageResponse: Codable {
    var data: Image
}

//MARK: Gallery / Post
struct Post {
    init() {
        postID = ""
        image = Image()
    }
    var postID: String
    var image: Image
}

//MARK: Favorite
struct FavoriteResponse: Codable {
    struct Favorite: Codable {
        var id: String?
        var title: String?
        var description: String?
        var cover: String?
        var account_url: String?
        var account_id: Int?
        var views: Int?
        var ups: Int?
        var downs: Int?
        var favorite: Bool?
        var favorite_count: Int?
    }
    var data: [Favorite]
}

//MARK: Avatar
struct AvatarResponse: Codable {
    struct Avatar: Codable {
        var avatar: String
    }
    var data: Avatar
}

public class ImgurAPIClient {
 
    public var ClientID = "3aab9940d90a6ac"
    
    init() {
        
    }

    enum ImgurError: Error {
        case invalidURL
        case notLoggedIn
        case apiError
    }
    
    enum SortSearch : String {
        case day
        case week
        case month
        case year
        case all
    }
    
    //MARK: setAuthBearerHeader
    private func setAuthBearerHeader(urlRequest: inout URLRequest) throws {
        let access_token = UserDefaults.standard.string(forKey: "access_token")
        
        if (access_token?.isEmpty == true) {
            throw ImgurError.notLoggedIn
        }
        let data = "Bearer " + access_token!
        urlRequest.setValue(data, forHTTPHeaderField: "Authorization")
    }
    
    //MARK: setAuthClientIDHeader
    private func setAuthClientIDHeader(urlRequest: inout URLRequest) throws {
        let access_token = UserDefaults.standard.string(forKey: "access_token")

        if (access_token?.isEmpty == true) {
            throw ImgurError.notLoggedIn
        }
        let data = "Bearer " + access_token!
        urlRequest.setValue(data, forHTTPHeaderField: "Authorization")
    }
    
    //MARK: handleClientError
    private func handleClientError(err: Error) {
        print("CLIENT ERROR")
        print(err)
    }
    
    //MARK: handleAPIError
    private func handleAPIError(resp: URLResponse) {
        print("API ERROR")
        print(resp)
    }
    
    //MARK: getAvatar
    func getAvatar(username: String) throws -> String {
        let session = URLSession.shared
        var urlAvatar = "url"
        var done = false
        
        guard let url = URL(string: "https://api.imgur.com/3/account/" + username + "/avatar") else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 100)
        urlRequest.httpMethod = "GET"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleAPIError(resp: response!)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            let avatar = try! JSONDecoder().decode(AvatarResponse.self, from: data!)
            
            urlAvatar = avatar.data.avatar
            done = true
        })
        task.resume()
        while (done == false) {}
        return urlAvatar
    }

    //MARK: fetchPageFavorite
    private func fetchPageFavorite(username: String, page: Int) throws -> [FavoriteResponse.Favorite] {
        let session = URLSession.shared
        var pageFav = [FavoriteResponse.Favorite]()
        var done = false
          
        guard let url = URL(string: "https://api.imgur.com/3/account/" + username + "/favorites/\(page)") else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
        urlRequest.httpMethod = "GET"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
          
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            let favResp = try! JSONDecoder().decode(FavoriteResponse.self, from: data!)
              
            pageFav = favResp.data
            done = true
          })
          task.resume()
          while (done == false) {}
          return pageFav
    }
    
    //MARK: getFavorites
    func getFavorites(username: String) throws -> [Post] {
        var favPosts = [Post]()
        let page = 0
        let favs = try self.fetchPageFavorite(username: username, page: page)
        for fav in favs {
            var post = Post()
            var image = try self.getImage(username: username, id: fav.cover!)
            if image.title == nil {image.title = fav.title}
            if image.description == nil {image.description = fav.description}
            if image.account_id == nil {image.account_id = fav.account_id}
            if image.views == nil {image.views = fav.views}
            if image.account_url == nil {image.account_url = fav.account_url}
            post.postID = fav.id!
            post.image = image
            favPosts.append(post)
        }
        return favPosts
    }
    
    //MARK: getFavoritesID
    func getFavoritesID(username: String) throws -> [String] {
        var favPosts = [String]()
        let page = 0
        let favs = try self.fetchPageFavorite(username: username, page: page)
        for fav in favs {
            if fav.id != nil {
                favPosts.append(fav.id!)
            }
            if fav.cover != nil {
                favPosts.append(fav.cover!)
            }
        }
        return favPosts
    }

    //MARK: getImage
    func getImage(username: String, id: String) throws -> Image {
        let session = URLSession.shared
        var image = Image()
        var done = false
        
        guard let url = URL(string: "https://api.imgur.com/3/account/" + username + "/image/" + id) else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 100)
        urlRequest.httpMethod = "GET"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleAPIError(resp: response!)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            let imgResp = try! JSONDecoder().decode(ImageResponse.self, from: data!)
            
            image = imgResp.data
            done = true
        })
        task.resume()
        while (done == false) {}
        return image
    }
    
    //MARK: fetchUserImagePage
    private func fetchUserImagePage(username: String, page: Int) throws -> [Image] {
        let session = URLSession.shared
        var pageImage = [Image]()
        var done = false
          
        guard let url = URL(string: "https://api.imgur.com/3/account/" + username + "/submissions/\(page)") else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
        urlRequest.httpMethod = "GET"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
          
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            let img = try! JSONDecoder().decode(MultipleImagesResponse.self, from: data!)
              
            pageImage = img.data
            done = true
          })
          task.resume()
          while (done == false) {}
          return pageImage
    }

    //MARK: getUserImage
    func getUserImage(username: String) throws -> [Post] {
        var posts = [Post]()
        let userImagePage = try self.fetchUserImagePage(username: username, page: 0)
        
        for img in userImagePage {
            var post = Post()
            post.postID = img.id!
            post.image = img
            posts.append(post)
        }
        return posts
    }

    //MARK: fetchOneSearch
    private func fetchOneSearch(searchKey: String, filter: SortSearch, page: Int) throws -> [FavoriteResponse.Favorite] {
        let session = URLSession.shared
        var imgSearch = [FavoriteResponse.Favorite]()
        var done = false
          
        guard let url = URL(string: "https://api.imgur.com/3/gallery/search/top/\(filter.rawValue)/\(page)?q="+searchKey) else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
        urlRequest.httpMethod = "GET"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
          
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            let imgs = try! JSONDecoder().decode(FavoriteResponse.self, from: data!)
              
            imgSearch = imgs.data
            done = true
        })
        task.resume()
        while (done == false) {}
        return imgSearch
    }
    
    private func transformSearchKeys(keywords: [String]) -> String {
        var search = ""
        
        for key in keywords {
            search += key + "+"
        }
        return search
    }
    
    //MARK: getSearchResult
    func getSearchResult(username: String, keywords: [String], sort: SortSearch) throws -> [Post] {
        var sortkey = sort
        if sortkey != SortSearch.day && sortkey != SortSearch.week && sortkey != SortSearch.month && sortkey != SortSearch.year {
            sortkey = SortSearch.all
        }
        var posts = [Post]()
        let searchKey = self.transformSearchKeys(keywords: keywords)

        let resultSearch = try self.fetchOneSearch(searchKey: searchKey, filter: sort, page: 0)

        for res in resultSearch {
            var post = Post()
            if (res.cover != nil) {
            var image = try self.getImage(username: username, id: res.cover!)
                if image.title == nil {image.title = res.title}
                if image.description == nil {image.description = res.description}
                if image.account_id == nil {image.account_id = res.account_id}
                if image.views == nil {image.views = res.views}
                if image.account_url == nil {image.account_url = res.account_url}
                post.postID = res.id!
                post.image = image
                posts.append(post)
            }
        }
        return posts
    }
    
}
