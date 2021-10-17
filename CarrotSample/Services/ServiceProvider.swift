//
//  ServiceProvider.swift
//  CarrotSample
//
//  Created by Eido Goya on 2021/10/17.
//

import Alamofire
import UIKit

struct ServiceProvider {
    let bookService: BookServiceProtocol!
    let memoryCacheService: MemoryCacheServiceProtocol!
    let diskCacheService: DiskCacheServiceProtocol!
}

extension ServiceProvider {
    static func resolve() -> ServiceProvider {
        return ServiceProvider(bookService: BookService(session: Session.default),
                               memoryCacheService: MemoryCacheService(imageCache: NSCache<NSString, UIImage>()),
                               diskCacheService: DiskCacheService(fileManager: FileManager.default))
    }
}
