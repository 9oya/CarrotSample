//
//  SceneDelegate.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit
import Alamofire

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let vc = SearchViewController()
        let configurator = SearchScreenConfigurator()
        
        let provider = ServiceProvider(
            bookService: BookService(session: Session.default),
            memoryCacheService: MemoryCacheService(imageCache: NSCache<NSString, UIImage>()),
            diskCacheService: DiskCacheService(fileManager: FileManager.default))
        let imgFetchService = ImageFetchService(provider: provider)
        configurator.configureModuleForViewInput(viewInput: vc,
                                                 provider: provider,
                                                 imgFetchService: imgFetchService)
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }


}

