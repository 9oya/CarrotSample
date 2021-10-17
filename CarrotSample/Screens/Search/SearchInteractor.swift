//
//  SearchInteractor.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import UIKit
import Alamofire

protocol SearchInteractorInput {
    func searchBooksWith(keyword: String,
                         isScrolled: Bool)
    func numberOfBooks() -> Int
    func configureTableCell(cell: BookTableCell,
                            index: Int)
    func isbn(index: Int) -> String
}

protocol SearchInteractorOutput: AnyObject {
    func tableViewNeedUpdate()
    func scrollTableViewToTop()
}

class SearchInteractor {
    
    var output: SearchInteractorOutput!
    var provider: ServiceProvider!
    var imgFetchService: ImageFetchServiceProtocol!
    
    private var currPage = 1
    var currSearchRequest: DataRequest?
    var currDownlowdRequest: DownloadRequest?
    var books: [BookSearchModel]?
    
    var imgCacheDict: [String:UIImage] = [:]
}

extension SearchInteractor: SearchInteractorInput {
    
    func searchBooksWith(keyword: String, isScrolled: Bool) {
        currPage = !isScrolled ? 1 : currPage
        currSearchRequest?.cancel()
        currSearchRequest = provider
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
                    self.imgCacheDict = [:]
                }
                self.output.tableViewNeedUpdate()
                if !isScrolled && self.books?.count ?? 0 > 0 {
                    self.output.scrollTableViewToTop()
                }
            }
    }
    
    func numberOfBooks() -> Int {
        return books?.count ?? 0
    }
    
    func configureTableCell(cell: BookTableCell,
                            index: Int) {
        guard let book = books?[index] else { return }
        
        cell.titleLabel.text = book.title
        cell.subTitleLabel.text = book.subtitle
        
        if let cachedImg = self.imgCacheDict[book.isbn13] {
            cell.bookImgView.image = cachedImg
        } else {
            cell.bookImgView.image = imgFetchService.defaultImage()
        }
        if let imgUrl = book.image {
            imgFetchService
                .fetchImage(imgUrl: imgUrl) { image in
                    cell.bookImgView.image = image
                    self.imgCacheDict[book.isbn13] = image
                }
        } else {
            cell.bookImgView.image = imgFetchService.defaultImage()
        }
    }
    
    func isbn(index: Int) -> String {
        return books![index].isbn13
    }
}
