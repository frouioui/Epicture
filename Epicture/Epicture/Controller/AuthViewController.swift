//
//  AuthViewController.swift
//  Epicture
//
//  Created by Florent Poinsard on 9/30/19.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func testAuth(_ sender: UIButton) {
        print(UserDefaults.standard.string(forKey: "refresh_token") as Any)
        print(UserDefaults.standard.string(forKey: "access_token") as Any)
        print(UserDefaults.standard.string(forKey: "account_username") as Any)
        print(UserDefaults.standard.string(forKey: "account_id") as Any)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.set("", forKey: "refresh_token")
        UserDefaults.standard.set("", forKey: "access_token")
        UserDefaults.standard.set("", forKey: "account_username")
        UserDefaults.standard.set("", forKey: "account_id")
    }
    
    @IBAction func testAPI(_ sender: UIButton) {
        print("get avatar")
        let client = ImgurAPIClient()

        do {
            var avatar_url = try client.getVotesPost(postId: "GL6t82p")
            print(avatar_url)
            let res = try client.voteManagePost(postId: "GL6t82p", vote: VotePost.veto)
            print(res)
            avatar_url = try client.getVotesPost(postId: "GL6t82p")
            print(avatar_url)
        } catch let err {
            print(err)
        }
    }

    //MARK: Actions
    @IBAction func connectWithImgur(_ sender: UIButton) {
        let client = ImgurAPIClient()

        guard let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=" + client.ClientID + "&response_type=token&state=test") else {
            return
        }
        UIApplication.shared.open(url)
//        loadFavoriteFromImgur()
//        loadUserFeedFromImgur()
//        openTabBarController()
    }

    //MARK: Private function
//    private func openTabBarController() {
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
//
//        mainTabBarController.modalPresentationStyle = .fullScreen
//        self.present(mainTabBarController, animated: false, completion: nil)
//    }
    
}
