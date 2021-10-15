//
//  SearchPresenter.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import UIKit

class SearchPresenter {
    var view: SearchViewInput!
    var interactor: SearchInteractorInput!
}

extension SearchPresenter: SearchViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func searchBooksWith(keyword: String, isScrolled: Bool) {
        interactor.searchBooksWith(keyword: keyword, isScrolled: isScrolled)
    }
    
    func numberOfBooks() -> Int {
        return interactor.numberOfBooks()
    }
}

extension SearchPresenter: SearchInteractorOutput {
    func tableViewNeedUpdate() {
        view.tableViewNeedUpdate()
    }
    
    func scrollTableViewToTop() {
        view.scrollTableViewToTop()
    }
}
