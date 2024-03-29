//
//  SceneDelegate.swift
//  Epicture
//
//  Created by Florent Poinsard on 9/30/19.
//  Copyright © 2019 Florent Poinsard. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func getQueryStringParameter(url: URL, param: String) -> String? {
      guard let url = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            let str = context.url.absoluteString
            let items =  str.components(separatedBy: "&")
            if (items.count != 6 ) {
                // error, is not the url callback from Imgur's API
                return
            }
            
            let access_token = items[0].components(separatedBy: "#")
            let refresh_token = items[3].components(separatedBy: "=")
            let account_username = items[4].components(separatedBy: "=")
            let account_id = items[5].components(separatedBy: "=")
            
            if (access_token.count != 2 || access_token[1].components(separatedBy: "=").count != 2 || access_token[1].components(separatedBy: "=")[0] != "access_token" ||
                refresh_token.count != 2 || refresh_token[0] != "refresh_token" ||
                account_username.count != 2 || account_username[0] != "account_username" ||
                account_id.count != 2 || account_id[0] != "account_id") {
                
                // error, is not the url callback from Imgur's API
                return
            }

            UserDefaults.standard.set(refresh_token[1], forKey: "refresh_token")
            UserDefaults.standard.set(access_token[1].components(separatedBy: "=")[1], forKey: "access_token")
            UserDefaults.standard.set(account_username[1], forKey: "account_username")
            UserDefaults.standard.set(account_id[1], forKey: "account_id")
        }
        loadFavoriteFromImgur()
        loadUserFeedFromImgur()
        openTabBarController()
    }

    private func openTabBarController() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyBoard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController

        mainTabBarController.modalPresentationStyle = .fullScreen
        window?.rootViewController = mainTabBarController
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

