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
        interactor.numberOfBooks()
    }
    
    func configureTableCell(cell: BookTableCell, index: Int) {
        interactor.configureTableCell(cell: cell, index: index)
    }
    
    func isbn(index: Int) -> String {
        interactor.isbn(index: index)
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
