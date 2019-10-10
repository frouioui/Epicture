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
    
    //MARK: Actions
    @IBAction func connectWithImgur(_ sender: UIButton) {
//        let authSession = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//        let authURL = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=3aab9940d90a6ac&response_type=token&state=test")!
        
        guard let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=3aab9940d90a6ac&response_type=token&state=test") else {
                return
            }
            UIApplication.shared.open(url)
//        let authTask = authSession.dataTask(with: authURL, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            guard let response = response else {
//                return
//            }
//            print("toto")
//            print(response)
//            print("tata")
//        })
//
//        authTask.resume()
    }
    
}
