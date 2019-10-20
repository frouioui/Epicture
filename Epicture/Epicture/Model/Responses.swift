//
//  Responses.swift
//  Epicture
//
//  Created by Cecile on 08/10/2019.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import Foundation

//MARK: Upload Image
struct ErrorResponseUpload: Codable {
    struct Err: Codable {
        var message: String = ""
    }
    var error: Err
}

struct UploadResponseError: Codable {
    var data: ErrorResponseUpload
}

struct UploadImage: Codable {
    var image: String = ""
    var type: String = "base64"
    var title: String = ""
    var description: String = ""
}

struct UploadedImage: Codable {
    var image: String = ""
    var type: String = "base64"
    var title: String = ""
    var description: String = ""
}

struct ResponseUploadImage: Codable {
    struct DataResp: Codable {
        var id: String = ""
    }
    var data: DataResp
}


//MARK: Votes
enum VotePost : String {
    case up
    case down
    case veto
}

struct VotesManageData: Codable {
    init() {
        data = false
    }
    var data: Bool
}

struct VotesResponse: Codable {
    init() {
        data = VotesData()
    }
    struct VotesData: Codable {
        init() {
            ups = 0
            downs = 0
        }
        var ups: Int
        var downs: Int
    }
    var data: VotesData
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

struct ErrorResponse: Codable {
    init() {
        error = ""
    }
    var error: String
}

struct FavoriteAlbumManageResponseError: Codable {
    init() {
        data = ErrorResponse()
    }
    var data: ErrorResponse
}

struct FavoriteAlbumManageResponse: Codable {
    init() {
        data = ""
    }
    var data: String
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
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                self.handleAPIError(resp: response!)
                    done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
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
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
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
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                self.handleAPIError(resp: response!)
                    done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
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
          
        guard let url = URL(string: "https://api.imgur.com/3/account/" + username + "/images/\(page)") else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
        urlRequest.httpMethod = "GET"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
          
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
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
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
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
    
    //MARK: favoriteOneAlbum
    private func favoriteOneAlbum(postId: String) throws -> Bool {
        let session = URLSession.shared
        var ok = false
        var done = false
          
        guard let url = URL(string: "https://api.imgur.com/3/album/" + postId + "/favorite") else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
        urlRequest.httpMethod = "POST"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
          
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) || httpResponse.statusCode == 404 else{
                self.handleAPIError(resp: response!)
                done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
                return
            }

            do {
                _ = try JSONDecoder().decode(FavoriteAlbumManageResponse.self, from: data!)
                ok = true
            } catch {
                print("error: this ID is not an album, instead try the favoriteOnePicture function")
                ok = false
            }
            done = true
        })
        task.resume()
        while (done == false) {}
        return ok
    }
    
    //MARK: favoriteOnePicture
    private func favoriteOnePicture(imageId: String) throws -> Bool {
        let session = URLSession.shared
        var ok = false
        var done = false
          
        guard let url = URL(string: "https://api.imgur.com/3/image/" + imageId + "/favorite") else {
            throw ImgurError.invalidURL
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
        urlRequest.httpMethod = "POST"

        try self.setAuthBearerHeader(urlRequest: &urlRequest)
          
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) || httpResponse.statusCode == 404 else{
                self.handleAPIError(resp: response!)
                done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
                return
            }

            do {
                _ = try JSONDecoder().decode(FavoriteAlbumManageResponse.self, from: data!)
                ok = true
            } catch {
                print("error, not a picture, try the favoriteOneAlbum function")
                ok = false
            }
            done = true
        })
        task.resume()
        while (done == false) {}
        return ok
    }
    
    //MARK: manageThisFavorite
    func manageThisFavorite(id: String) throws -> Bool {
        var fav = try self.favoriteOneAlbum(postId: id)
        if fav == false {
            fav = try self.favoriteOnePicture(imageId: id)
        }
        print(fav)
        return fav
    }
    
    //MARK: getVotesPost
//    func getVotesPost(postId: String) throws -> VotesResponse.VotesData {
//        let session = URLSession.shared
//        var voteData = VotesResponse.VotesData()
//        var done = false
//
//        guard let url = URL(string: "https://api.imgur.com/3/gallery/" + postId + "/votes") else {
//            throw ImgurError.invalidURL
//        }
//
//        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
//        urlRequest.httpMethod = "GET"
//
//        try self.setAuthBearerHeader(urlRequest: &urlRequest)
//
//        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
//            if error != nil || data == nil {
//                self.handleClientError(err: error!)
//                done = true
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
//                self.handleAPIError(resp: response!)
//                done = true
//                return
//            }
//            guard let mime = response?.mimeType, mime == "application/json" else {
//                print("Wrong MIME type!")
//                done = true
//                return
//            }
//
//            let votesResp = try! JSONDecoder().decode(VotesResponse.self, from: data!)
//
//            voteData = votesResp.data
//            done = true
//        })
//        task.resume()
//        while (done == false) {}
//        return voteData
//    }
//
//    //MARK: voteManagePost
//    func voteManagePost(postId: String, vote: VotePost) throws -> Bool {
//        let session = URLSession.shared
//        var voteManageData = false
//        var done = false
//
//        guard let url = URL(string: "https://api.imgur.com/3/gallery/" + postId + "/vote/" + vote.rawValue) else {
//            throw ImgurError.invalidURL
//        }
//
//        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:100)
//        urlRequest.httpMethod = "POST"
//
//        try self.setAuthBearerHeader(urlRequest: &urlRequest)
//
//        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
//            if error != nil || data == nil {
//                self.handleClientError(err: error!)
//                done = true
//                return
//            }
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
//                self.handleAPIError(resp: response!)
//                done = true
//                return
//            }
//            guard let mime = response?.mimeType, mime == "application/json" else {
//                print("Wrong MIME type!")
//                done = true
//                return
//            }
//
//            let votesResp = try! JSONDecoder().decode(VotesManageData.self, from: data!)
//
//            voteManageData = votesResp.data
//            done = true
//        })
//        task.resume()
//        while (done == false) {}
//        return voteManageData
//    }

    //MARK: uploadPhoto
    func uploadPhoto(photoBase64: String, title: String?, description: String?) throws -> String {
        let session = URLSession.shared
        var uploadedData = ResponseUploadImage.DataResp()
        var done = false

        guard let url = URL(string: "https://api.imgur.com/3/upload") else {
            throw ImgurError.invalidURL
        }
        
        let jsonObject: [String: Any] = [
            "image": photoBase64,
            "title": title as Any,
            "description": description as Any
        ]

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval:500000)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
        
        try self.setAuthBearerHeader(urlRequest: &urlRequest)

        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil || data == nil {
                self.handleClientError(err: error!)
                done = true
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
                self.handleAPIError(resp: response!)
                done = true
                return
            }
            guard let mime = response?.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                done = true
                return
            }

            let uploadResp = try! JSONDecoder().decode(ResponseUploadImage.self, from: data!)
            uploadedData = uploadResp.data
            done = true
        })
        task.resume()
        while (done == false) {}
        return uploadedData.id
    }
}
