//
//  DetailInteractor.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import Foundation
import Alamofire

protocol DetailInteractorInput {
    func loadBookInfo(isbn: String)
    func numberOfBookInfos() -> Int
    func configureTableCell(cell: BookInfoTableCell,
                            index: Int)
    func configureTableCell(cell: BookInfoImgTableCell,
                            index: Int)
    func configureTableCell(cell: BookInfoPdfTableCell,
                            index: Int)
}

protocol DetailInteractorOutput {
    func layoutViews()
    func scrollTableViewToTop()
}

class DetailInteractor {
    
    struct Dependency {
        let bookService: BookServiceProtocol!
        let memoryCacheService: MemoryCacheServiceProtocol!
        let diskCacheService: DiskCacheServiceProtocol!
    }
    
    var output: DetailInteractorOutput!
    var dependency: Dependency!
    
    var currDetailRequest: DataRequest?
    var currDownlowdRequest: DownloadRequest?
    var bookInfo: BookInfoModel?
    var pdfDictArr: [[String: String]] = [[:]]
}

extension DetailInteractor: DetailInteractorInput {
    func loadBookInfo(isbn: String) {
        currDetailRequest?.cancel()
        currDetailRequest = dependency
            .bookService
            .detail(isbn: isbn) { [weak self] result in
                guard let `self` = self else { return }
                self.bookInfo = result
                self.output.layoutViews()
                if self.bookInfo != nil {
                    self.output.scrollTableViewToTop()
                }
            }
    }
    
    func numberOfBookInfos() -> Int {
        guard let bookInfo = self.bookInfo else {
            return 0
        }
        var numberOfBookInfos = 14
        if let pdfs = bookInfo.pdf {
            pdfDictArr = [[:]]
            for pdf in pdfs {
                numberOfBookInfos += 1
                pdfDictArr.append([pdf.key:pdf.value])
            }
        }
        return numberOfBookInfos
    }
    
    func configureTableCell(cell: BookInfoTableCell, index: Int) {
        guard let bookInfo = self.bookInfo else { return }
        var titleText = ""
        var descText = ""
        
        switch index {
        case 0:
            break
        case 1:
            titleText = "title"
            descText = bookInfo.title
        case 2:
            titleText = "subtitle"
            descText = bookInfo.subtitle
        case 3:
            titleText = "author"
            descText = bookInfo.authors
        case 4:
            titleText = "publisher"
            descText = bookInfo.publisher!
        case 5:
            titleText = "language"
            descText = bookInfo.language!
        case 6:
            titleText = "isbn10"
            descText = bookInfo.isbn10!
        case 7:
            titleText = "isbn13"
            descText = bookInfo.isbn13
        case 8:
            titleText = "pages"
            descText = bookInfo.pages!
        case 9:
            titleText = "year"
            descText = bookInfo.year!
        case 10:
            titleText = "rating"
            descText = bookInfo.rating!
        case 11:
            titleText = "desc"
            descText = bookInfo.desc!
        case 12:
            titleText = "price"
            descText = bookInfo.price!
        case 13:
            titleText = "url"
            descText = bookInfo.url!
        default:
            if !self.pdfDictArr.isEmpty,
               let pdfDict = pdfDictArr[index-13].first {
                titleText = pdfDict.key
                descText = pdfDict.value
            }
        }
        
        cell.titleLabel.text = titleText
        cell.subTitleLabel.text = descText
    }
    
    func configureTableCell(cell: BookInfoPdfTableCell,
                            index: Int) {
        if let pdfDict = pdfDictArr[index-13].first {
            cell.loadPdfDocs(url: URL(string: pdfDict.value)!)
        }
        
    }
    
    func configureTableCell(cell: BookInfoImgTableCell,
                            index: Int) {
        if let bookInfo = self.bookInfo,
           let imgUrl = bookInfo.image {
            fetchImage(imgUrl: imgUrl) { img in
                cell.bookImgView?.image = img
            }
        } else {
            cell.imageView?.image = defaultImage()
        }
    }
}

extension DetailInteractor {
    func convertToDictionary(data: Data) -> [String: String]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        } catch {
            print(error.localizedDescription)
        }
        return nil
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
