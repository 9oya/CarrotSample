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
    case downloadImage(url: String, etag: String)

    static let baseURLString = "https://api.itbook.store"

    var method: HTTPMethod {
        switch self {
        case .searchBooks, .downloadImage:
            return .get
        }
     }

    var path: String {
        switch self {
        case let .searchBooks(keyword, page):
            return "/1.0/search/\(keyword)/\(page)"
        case let .downloadImage(url, _):
            return url
        }
    }
    
    private func additionalHttpHeaders() -> [(String, String)] {
        var headers = [(String, String)]()
        switch self {
        case let .downloadImage(_ , etag):
            headers.append((etag, "If-None-Match"))
        default:
            break
        }
        return headers
    }

    func asURLRequest() throws -> URLRequest {
        let url = try APIRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        switch self {
        case .downloadImage(let url, _):
            urlRequest = URLRequest(url: try url.asURL())
        default:
            break
        }
        
        urlRequest.httpMethod = method.rawValue
        
        additionalHttpHeaders().forEach { header in
            urlRequest.addValue(header.1, forHTTPHeaderField: header.0)
        }

        return urlRequest
    }
}
