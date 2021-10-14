//
//  BookService.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/14.
//

import Alamofire

enum Router: URLRequestConvertible
{
    case searchBooks(keyword: String, page: Int)

    static let baseURLString = "https://api.itbook.store"

    var method: HTTPMethod
    {
        switch self {
        case .searchBooks:
            return .get
        }
     }

    var path: String
    {
        switch self {
        case let .searchBooks(keyword, page):
            return "/1.0/search/\(keyword)/\(page)"
        }
    }

    // MARK: URLRequestConvertible

    func asURLRequest() throws -> URLRequest
    {
        let url = try Router.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue


        return urlRequest
    }
}

final class BookService {
    
    private let session: SessionProtocol
    
    init(session: SessionProtocol) {
        self.session = session
    }
    
    @discardableResult
    func search(keywork: String,
                page: Int,
                completionHandler: @escaping (SearchBookModel) -> Void)
    -> DataRequest {
        let request = Router.searchBooks(keyword: keywork, page: page)
        return session
            .request(request, interceptor: nil)
            .responseData { response in
                let decoder = JSONDecoder()
                if let result = try? decoder.decode(SearchBookModel.self, from: response.value!) {
                    completionHandler(result)
                }
            }
    }
}
