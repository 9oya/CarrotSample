//
//  SearchInteractor.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit
import Alamofire

protocol SearchInteractorInput {
    func searchBooksWith(keyword: String, isScrolled: Bool)
    func numberOfBooks() -> Int
}

protocol SearchInteractorOutput: AnyObject {
    func tableViewNeedUpdate()
    func scrollTableViewToTop()
}

class SearchInteractor {
    
    struct Dependency {
        let bookService: BookServiceProtocol!
        let memoryCacheService: MemoryCacheServiceProtocol!
        let diskCacheService: DiskCacheServiceProtocol!
    }
    
    var output: SearchInteractorOutput!
    var dependency: Dependency!
    
    private var currPage = 1
    var currSearchRequest: DataRequest?
    var books: [BookModel]?
}

extension SearchInteractor: SearchInteractorInput {
    
    func searchBooksWith(keyword: String, isScrolled: Bool) {
        currPage = !isScrolled ? 1 : currPage
        currSearchRequest?.cancel()
        currSearchRequest = dependency
            .bookService
            .search(keywork: keyword,
                    page: currPage) { [weak self] result in
                guard let `self` = self else { return }
                self.currPage += 1
                if isScrolled {
                    if self.books != nil && result.books != nil {
                        self.books! += result.books!
                    } else {
                        self.books = result.books
                    }
                } else {
                    self.books = result.books
                }
                self.output.tableViewNeedUpdate()
            }
    }
    
    func numberOfBooks() -> Int {
        return books?.count ?? 0
    }
}
