//
//  AppDependency.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/13.
//

import Alamofire
import Foundation
import UIKit

struct AppDependency {
    let provider: ServiceProvider
    let imgFetchService: ImageFetchServiceProtocol
}

extension AppDependency {
    static func resolve() -> AppDependency {
        let _provider = ServiceProvider(
            bookService: BookService(session: Session.default),
            memoryCacheService: MemoryCacheService(imageCache: NSCache<NSString, UIImage>()),
            diskCacheService: DiskCacheService(fileManager: FileManager.default))
        
        return AppDependency(
            provider: _provider,
            imgFetchService: ImageFetchService(provider: _provider))
        
    }
}
