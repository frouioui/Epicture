//
//  EpictureTests.swift
//  EpictureTests
//
//  Created by Florent Poinsard on 9/30/19.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import XCTest
@testable import Epicture

class EpictureTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetAvatarImgur() {
        let client = ImgurAPIClient()
        
        UserDefaults.standard.set("6535674d8df6bef15f43f04b168ee1bbdc6e2f79", forKey: "access_token")
        let url = try! client.getAvatar(username: "testfouioui")
        
        XCTAssertEqual(url, "https://imgur.com/user/testfouioui/avatar?maxwidth=290")
    }
    
    func testGetFavoritesImgur() {
        let client = ImgurAPIClient()
        
        UserDefaults.standard.set("6535674d8df6bef15f43f04b168ee1bbdc6e2f79", forKey: "access_token")
        
        let favs = try! client.getFavorites(username: "testfouioui")
        let favsID = try! client.getFavoritesID(username: "testfouioui")
        
        var ok = true
        for fav in favs {
            var favFound = false
            for favID in favsID {
                if favID == fav.postID || favID == fav.image.id {
                    favFound = true
                    break
                }
            }
            if favFound == false {
                ok = false
                break
            }
        }
        
        XCTAssertEqual(ok, true)
    }

    func testGetImageImgur() {
        let client = ImgurAPIClient()
        
        UserDefaults.standard.set("6535674d8df6bef15f43f04b168ee1bbdc6e2f79", forKey: "access_token")
        
        let img = try! client.getImage(username: "testfouioui", id: "TVYruzE")
        
        XCTAssertEqual(img.id!, "TVYruzE")
        XCTAssertEqual(img.title!, "api imgur test")
        XCTAssertEqual(img.description!, "this is a wrapper of the Imgur API")
    }
    
    func testGetUserImageImgur() {
        let client = ImgurAPIClient()
        
        UserDefaults.standard.set("6535674d8df6bef15f43f04b168ee1bbdc6e2f79", forKey: "access_token")
        
        let posts = try! client.getUserImage(username: "testfouioui")
        
        var ok = false
        for post in posts {
            if post.image.id == "TVYruzE" && post.image.title == "api imgur test" && post.image.description == "this is a wrapper of the Imgur API" {
                ok = true
            }
        }
        
        XCTAssertEqual(ok, true)
    }
    
    func testManageFavorite() {
        let client = ImgurAPIClient()
        
        UserDefaults.standard.set("6535674d8df6bef15f43f04b168ee1bbdc6e2f79", forKey: "access_token")
        
        _ = try! client.manageThisFavorite(id: "TVYruzE")
        var favsID = try! client.getFavoritesID(username: "testfouioui")
        
        var ok = true
        for favID in favsID {
            if favID == "TVYruzE" {
                ok = false
            }
        }
        XCTAssertEqual(ok, true)
        _ = try! client.manageThisFavorite(id: "TVYruzE")
        favsID = try! client.getFavoritesID(username: "testfouioui")
        
        ok = false
        for favID in favsID {
            if favID == "TVYruzE" {
                ok = true
            }
        }
        XCTAssertEqual(ok, true)
    }
}
