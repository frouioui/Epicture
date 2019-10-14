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
    
    //MARK: Actions
    @IBAction func connectWithImgur(_ sender: UIButton) {
        guard let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=3aab9940d90a6ac&response_type=token&state=test") else {
            return
        }
        UIApplication.shared.open(url)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeView") as! FeedViewController
//
//        homeViewController.modalPresentationStyle = .fullScreen
//        self.present(homeViewController, animated: false, completion: nil)
    }
    
}
