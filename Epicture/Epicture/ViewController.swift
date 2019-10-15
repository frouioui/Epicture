//
//  ViewController.swift
//  Epicture
//
//  Created by Florent Poinsard on 9/30/19.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func testAuth(_ sender: UIButton) {
        print("test oauth")
        
        print(UserDefaults.standard.string(forKey: "refresh_token") as Any)
        print(UserDefaults.standard.string(forKey: "access_token") as Any)
        print(UserDefaults.standard.string(forKey: "account_username") as Any)
        print(UserDefaults.standard.string(forKey: "account_id") as Any)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        print("logout")
        
        UserDefaults.standard.set("", forKey: "refresh_token")
        UserDefaults.standard.set("", forKey: "access_token")
        UserDefaults.standard.set("", forKey: "account_username")
        UserDefaults.standard.set("", forKey: "account_id")
    }
    
    @IBAction func getAvatar(_ sender: UIButton) {
        print("get avatar")
        let client = ImgurAPIClient()

        do {
            let avatar_url = try client.getFavorites(username: UserDefaults.standard.string(forKey: "account_username")!)
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
    }
    
}
