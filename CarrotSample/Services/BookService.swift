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
}

final class BookService: BookServiceProtocol {
    
    private let session: SessionProtocol
    
    init(session: SessionProtocol) {
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
}
