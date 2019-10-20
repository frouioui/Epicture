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
    

    //MARK: - Connect With Imgur
    @IBAction func connectWithImgur(_ sender: UIButton) {
        let client = ImgurAPIClient()

        guard let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=" + client.ClientID + "&response_type=token&state=test") else {
            return
        }
        UIApplication.shared.open(url)
    }
}
