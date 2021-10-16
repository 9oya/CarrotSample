//
//  MockSession.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
@testable import Alamofire
@testable import CarrotSample


class MockSession: Session {
    
    var requestConvertible: URLRequestConvertible?
    var convertible: URLConvertible?
    
    override func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> DataRequest {
        self.requestConvertible = convertible
        return AF.request(convertible)
    }
    
    override func download(_ convertible: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, interceptor: RequestInterceptor? = nil, requestModifier: Session.RequestModifier? = nil, to destination: DownloadRequest.Destination? = nil) -> DownloadRequest {
        self.convertible = convertible
        return AF.download(convertible)
    }
}
