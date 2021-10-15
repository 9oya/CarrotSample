//
//  APIRouter.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/15.
//

import Alamofire

enum APIRouter: URLRequestConvertible
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

    func asURLRequest() throws -> URLRequest
    {
        let url = try APIRouter.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
}
