//
//  BookService.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/14.
//

import Alamofire

protocol BookServiceProtocol {
    func search(keywork: String,
                page: Int,
                completionHandler: @escaping (BookSearchResult) -> Void)
    -> DataRequest
    
    func detail(isbn: String,
                completionHandler: @escaping (BookInfoModel) -> Void)
    -> DataRequest
    
    func downloadImage(url: String,
                       completionHandler: @escaping (DownloadResult) -> Void)
    -> DownloadRequest
}

enum DownloadResult {
    case notModified(image: UIImage)
    case success(image: UIImage, etag: String)
    case failure
}

final class BookService: BookServiceProtocol {
    
    private let session: Session
    
    init(session: Session) {
        self.session = session
    }
    
    @discardableResult
    func search(keywork: String,
                page: Int,
                completionHandler: @escaping (BookSearchResult) -> Void)
    -> DataRequest {
        let request = APIRouter.searchBooks(keyword: keywork, page: page)
        return session
            .request(request, interceptor: nil)
            .responseData { response in
                let decoder = JSONDecoder()
                if let data = response.value,
                   let result = try? decoder.decode(BookSearchResult.self, from: data) {
                    completionHandler(result)
                }
            }
    }
    
    func detail(isbn: String,
                completionHandler: @escaping (BookInfoModel) -> Void)
    -> DataRequest {
        let request = APIRouter.bookDetail(isbn: isbn)
        return session
            .request(request)
            .responseData { response in
                let decoder = JSONDecoder()
                if let data = response.value,
                   let result = try? decoder.decode(BookInfoModel.self, from: data) {
                    completionHandler(result)
                }
            }
    }
    
    func downloadImage(url: String,
                       completionHandler: @escaping (DownloadResult) -> Void)
    -> DownloadRequest {
        let etag = UserDefaults.standard.string(forKey: url) ?? ""
        return session
            .download(url, method: .get)
            .responseData { rsp in
                let rspEtag = rsp.response?.allHeaderFields["Etag"] as? String
                if etag == rspEtag,
                   let data = rsp.value,
                   let image = UIImage(data: data) {
                    completionHandler(.notModified(image: image))
                } else if let data = rsp.value,
                          let image = UIImage(data: data) {
                    completionHandler(.success(image: image, etag: rspEtag ?? etag))
                }
                completionHandler(.failure)
            }
    }
}
