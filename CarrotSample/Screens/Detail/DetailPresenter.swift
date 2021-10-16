//
//  DetailPresenter.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/16.
//

import UIKit

class DetailPresenter {
    var view: DetailViewInput!
    var interactor: DetailInteractorInput!
}

extension DetailPresenter: DetailViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
    }
    
    func loadBookInfo(isbn: String) {
        interactor.loadBookInfo(isbn: isbn)
    }
    
    func numberOfBookInfos() -> Int {
        interactor.numberOfBookInfos()
    }
    
    func configureTableCell(cell: BookInfoTableCell, index: Int) {
        interactor.configureTableCell(cell: cell, index: index)
    }
    
    func configureTableCell(cell: BookInfoImgTableCell,
                            index: Int) {
        interactor.configureTableCell(cell: cell, index: index)
    }
}

extension DetailPresenter: DetailInteractorOutput {
    func layoutViews() {
        view.layoutViews()
    }
    
    func scrollTableViewToTop() {
        view.scrollTableViewToTop()
    }
}
