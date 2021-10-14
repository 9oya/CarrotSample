//
//  MockSession.swift
//  CarrotSampleTests
//
//  Created by Eido Goya on 2021/10/15.
//

import Foundation
@testable import Alamofire
@testable import CarrotSample


class MockSession: SessionProtocol {
    
    var requestConvertible: URLRequestConvertible?
    
    func request(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor?) -> DataRequest {
        self.requestConvertible = convertible
        return AF.request(convertible)
    }
}
