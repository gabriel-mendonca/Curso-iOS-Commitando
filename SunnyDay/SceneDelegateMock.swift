//
//  SceneDelegateMock.swift
//  SunnyDay
//
//  Created by Gabriel on 30/03/24.
//

#if DEBUG
import UIKit
import RestaurantDomain

final class SceneDelegateMock: SceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: fileManagerURL)
        }
        
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    override func makeRemoteLoader() -> RestaurantLoader {
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return RestaurantLoaderMock()
        }
        
        return super.makeRemoteLoader()
    }
}

private final class RestaurantLoaderMock: RestaurantLoader {
    func load(completion: @escaping (Result<[RestaurantItem], RestaurantDomain.RestaurantResultError>) -> Void) {
        completion(.failure(.connectivity))
    }
}
#endif
