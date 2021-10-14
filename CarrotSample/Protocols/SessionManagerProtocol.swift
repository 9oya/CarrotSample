//
//  SessionManagerProtocol.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/14.
//

import Alamofire

protocol SessionProtocol {
    func request(_ convertible: URLRequestConvertible,
                 interceptor: RequestInterceptor?) -> DataRequest
}

extension Session: SessionProtocol {
}
