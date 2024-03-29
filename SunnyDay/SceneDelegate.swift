//
//  SceneDelegate.swift
//  SunnyDay
//
//  Created by Gabriel on 29/03/24.
//

import UIKit
import RestaurantDomain
import RestaurantUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        let session = URLSession(configuration: .ephemeral)
        let network = NetworkService(session: session)
        let url = URL(string: "https://raw.githubusercontent.com/comitando/assets/main/api/restaurant_list_endpoint.json")!
        let remoteService = RemoteRestaurantLoader(url: url, networkClient: network)
        
        let fileManagerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: "SunnyDay.store")
        let cache = CacheService(managerURL: fileManagerURL)
        let localService = LocalRestaurantLoader(cache: cache) {
            return Date()
        }
        
        let compositeService = RestaurantLoaderCompositeRemoteAndLocal(main: remoteService, fallback: localService)
        
        let controller = RestaurantListCompose.compose(service: compositeService)
        let navigation = UINavigationController(rootViewController: controller)
        window?.rootViewController = navigation
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}

