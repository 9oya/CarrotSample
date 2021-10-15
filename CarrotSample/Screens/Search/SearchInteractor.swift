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
    var currDownlowdRequest: DataRequest?
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
    
    func configureTableCell(cell: BookTableCell,
                            index: Int) {
        guard let book = books?[index] else { return }
        
        cell.titleLabel.text = book.title
        cell.subTitleLabel.text = book.subtitle
        
        cell.bookImgView.image = nil
        if let imgUrl = book.image {
            fetchImage(imgUrl: imgUrl) { image in
                cell.bookImgView.image = image
            }
        } else {
            cell.bookImgView.image = defaultImage()
        }
        
    }
    
    func defaultImage() -> UIImage {
        return UIImage(named: "")!
    }
    
    func fetchImage(imgUrl: String,
                    completion: @escaping (UIImage)->Void) {
        currDownlowdRequest?.cancel()
        currDownlowdRequest = dependency
            .bookService
            .downloadImage(url: imgUrl) { [weak self] result in
                guard let `self` = self else { return }
                var image: UIImage
                switch result {
                case .noModified:
                    if let memoryImg = self.dependency
                        .memoryCacheService
                        .fetch(key: imgUrl) {
                        image = memoryImg
                        completion(image)
                    } else if let diskImg = self.dependency
                                .diskCacheService
                                .fetch(key: imgUrl) {
                        image = diskImg
                        completion(image)
                    } else {
                        completion(self.defaultImage())
                    }
                case .success(let image, let etag):
                    self.dependency
                        .memoryCacheService
                        .store(key: imgUrl,
                               image: image)
                    self.dependency
                        .diskCacheService
                        .store(key: imgUrl,
                               image: image)
                    UserDefaults.standard.set(etag, forKey: imgUrl)
                case .failure:
                    break
                }
            }
    }
}
