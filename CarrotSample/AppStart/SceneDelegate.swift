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
    private let appDependency: AppDependency
    
    private override init() {
        self.appDependency = AppDependency.resolve()
    }
    
    init(dependency: AppDependency) {
        self.appDependency = dependency
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: rootViewController())
        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    private func rootViewController() -> SearchViewController {
        let vc = SearchViewController()
        let configurator = SearchScreenConfigurator()
        configurator.configureModuleForViewInput(
            viewInput: vc,
            provider: appDependency.provider,
            imgFetchService: appDependency.imgFetchService)
        return vc
    }
}
