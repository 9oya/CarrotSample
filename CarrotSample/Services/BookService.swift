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
    
//    func downloadImage(url: String,
//                       completionHandler: @escaping (DownloadResult) -> Void)
//    -> DataRequest
    
    func downloadImage(url: String,
                       completionHandler: @escaping (DownloadResult) -> Void)
    -> DownloadRequest
}

enum DownloadResult {
    case noModified
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
    
//    func downloadImage(url: String,
//                       completionHandler: @escaping (DownloadResult) -> Void)
//    -> DataRequest {
//        let etag = UserDefaults.standard.string(forKey: url)
//        let request = APIRouter.downloadImage(url: url,
//                                              etag: etag ?? "")
//        return session
//            .request(request, interceptor: nil)
//            .responseData { response in
//                if response.response?.statusCode == 304 {
//                    completionHandler(.noModified)
//                    return
//                }
//                let etag = response.response?.allHeaderFields["Etag"] as? String
//                if let data = response.value,
//                   let image = UIImage(data: data) {
//                    completionHandler(.success(image: image,
//                                               etag: etag!))
//                    return
//                }
//                completionHandler(.failure)
//            }
//    }
    
    func downloadImage(url: String,
                       completionHandler: @escaping (DownloadResult) -> Void)
    -> DownloadRequest {
        let etag = UserDefaults.standard.string(forKey: url) ?? ""
//        let headers: HTTPHeaders = [
//            "If-None-Match": etag
//        ]
        return session
            .download(url, method: .get)
            .responseData { rsp in
                let rspEtag = rsp.response?.allHeaderFields["Etag"] as? String
                if etag == rspEtag {
                    completionHandler(.noModified)
                } else if let data = rsp.value,
                          let image = UIImage(data: data) {
                    completionHandler(.success(image: image, etag: rspEtag ?? etag))
                }
                completionHandler(.failure)
            }
    }
}
