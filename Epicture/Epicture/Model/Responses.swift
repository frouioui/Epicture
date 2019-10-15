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

//MARK: Avatar
struct AvatarResponse: Codable {
    struct Avatar: Codable {
        var avatar: String
        var avatar_name: String
    }
    var data: Avatar
    var success: Bool
    var status: Int
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
    
    private func setAuthBearerHeader(urlRequest: inout URLRequest) throws {
        let access_token = UserDefaults.standard.string(forKey: "access_token")
        
        if (access_token?.isEmpty == true) {
            throw ImgurError.notLoggedIn
        }
        let data = "Bearer " + access_token!
        urlRequest.setValue(data, forHTTPHeaderField: "Authorization")
    }
    
    private func setAuthClientIDHeader(urlRequest: inout URLRequest) throws {
        let access_token = UserDefaults.standard.string(forKey: "access_token")

        if (access_token?.isEmpty == true) {
            throw ImgurError.notLoggedIn
        }
        let data = "Bearer " + access_token!
        urlRequest.setValue(data, forHTTPHeaderField: "Authorization")
    }
    
    private func handleClientError(err: Error) {
        print("CLIENT ERROR")
        print(err)
    }
    
    private func handleAPIError(resp: URLResponse) {
        print("API ERROR")
        print(resp)
    }
    
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

}
