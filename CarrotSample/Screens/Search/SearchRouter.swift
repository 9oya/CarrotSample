//
//  SearchRouter.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/17.
//

import UIKit

protocol SearchRouterInput {
    func pushToDetailScreen(from view: SearchViewController,
                            isbn: String)
}

class SearchRouter: SearchRouterInput {
    
    var provider: ServiceProvider!
    var imgFetchService: ImageFetchServiceProtocol!
    
    func pushToDetailScreen(from view: SearchViewController,
                            isbn: String) {
        let vc = DetailViewController()
        let configurator = DetailScreenConfigurator()
        configurator.configureModuleForViewInput(
            viewInput: vc,
            provider: self.provider,
            imgFetchService: self.imgFetchService,
            bookIsbn: isbn)
        view.navigationController?.pushViewController(vc, animated: true)
    }
}
