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
}

extension DetailPresenter: DetailInteractorOutput {
    func layoutViews() {
        view.layoutViews()
    }
}
