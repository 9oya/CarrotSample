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
    var currDownlowdRequest: DownloadRequest?
    var books: [BookSearchModel]?
    
    var imgCacheDict: [String:UIImage] = [:]
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
            cell.bookImgView.image = defaultImage()
        }
        if let imgUrl = book.image {
            fetchImage(imgUrl: imgUrl) { image in
                cell.bookImgView.image = image
                self.imgCacheDict[book.isbn13] = image
            }
        } else {
            cell.bookImgView.image = defaultImage()
        }
        
    }
    
    func defaultImage() -> UIImage {
        return UIImage(named: "default-book")!
    }
    
    func fetchImage(imgUrl: String,
                    completion: @escaping (UIImage)->Void) {
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
                                .fetch(key: URL(string: imgUrl)!.lastPathComponent) {
                        image = diskImg
                        self.dependency
                            .memoryCacheService
                            .store(key: imgUrl,
                                   image: image)
                        completion(image)
                    } else {
                        completion(self.defaultImage())
                    }
                case .success(let image, let etag):
                    self.dependency
                        .memoryCacheService
                        .store(key: imgUrl,
                               image: image)
                    let _ = self.dependency
                        .diskCacheService
                        .store(key: URL(string: imgUrl)!.lastPathComponent,
                               image: image)
                    UserDefaults.standard.set(etag, forKey: imgUrl)
                    completion(image)
                case .failure:
                    break
                }
            }
    }
}
